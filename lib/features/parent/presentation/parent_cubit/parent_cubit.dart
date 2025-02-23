import 'package:IOT_SmartHome/features/parent/presentation/parent_cubit/parent_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ParentCubit extends Cubit<ParentState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ParentCubit() : super(ParentInitial());

  void initialize({required String familyId}) {
    _initializeNotifications();
    _listenForNewOTPRequests(familyId);
    emit(ParentLoaded(familyId: familyId));
  }

  ///  Initialize Local Notifications  
  void _initializeNotifications() {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  ///  Listen for New OTP Requests  
  void _listenForNewOTPRequests(String familyId) {
    _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: familyId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _showLocalNotification(change.doc.data());
        }
      }
    });
  }

  ///  Show Local Notification for New OTP Request  
  Future<void> _showLocalNotification(Map<String, dynamic>? requestData) async {
    if (requestData == null) return;
    String deviceName = requestData['deviceName'] ?? '';
    String otp = requestData['otp'] ?? '';

    const androidDetails = AndroidNotificationDetails(
      'otp_channel',
      'OTP Requests',
      channelDescription: 'Notifications for OTP requests',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New OTP Request',
      'Child requested OTP for $deviceName. OTP: $otp',
      notificationDetails,
      payload: 'otp_request',
    );
  }

  //  Get Total Devices Count  
  Stream<int> getTotalDevicesCount(String familyId) {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //  Get Active Requests Count  
  Stream<int> getActiveRequestsCount(String familyId) {
    return _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: familyId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //Add Device--------
  Future<void> addDevice(String familyId, String name, bool isDangerous) async {
    try {
      await _firestore.collection('devices').add({
        'name': name,
        'status': false,
        'isDangerous': isDangerous,
        'familyId': familyId,
        'lastUsed': FieldValue.serverTimestamp(),
      });
      emit(DeviceAddedSuccess());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }

  /// Stream All Devices --------
  Stream<List<Map<String, dynamic>>> getDevices(String familyId) {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['name'],
                  'status': doc['status'],
                  'isDangerous': doc['isDangerous'],
                  'lastUsed': doc['lastUsed']?.toDate(),
                })
            .toList());
  }

  //Toggle Device Status-----------
  Future<void> toggleDeviceStatus(String deviceId, bool status) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({'status': status});
      emit(DeviceStatusUpdated());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }

  ///  Delete Device ---------- 
  Future<void> deleteDevice(String deviceId) async {
    try {
      await _firestore.collection('devices').doc(deviceId).delete();
      emit(DeviceDeletedSuccess());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }

  ///  Approve OTP Request  
  Future<void> approveRequest(String requestId) async {
    try {
      await _firestore.collection('otp_requests').doc(requestId).update({
        'status': 'approved',
        'approvedTimestamp': FieldValue.serverTimestamp(),
      });
      emit(OTPRequestApproved());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }

  ///  Reject OTP Request  
  Future<void> rejectRequest(String requestId) async {
    try {
      await _firestore.collection('otp_requests').doc(requestId).update({
        'status': 'rejected',
        'rejectedTimestamp': FieldValue.serverTimestamp(),
      });
      emit(OTPRequestRejected());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }
  ///  Get Stream of Pending OTP Requests  
Stream<QuerySnapshot<Map<String, dynamic>>> getOtpRequests(String familyId) {
  return _firestore
      .collection('otp_requests')
      .where('familyId', isEqualTo: familyId)
      .where('status', isEqualTo: 'pending')
      .snapshots();
}
}
