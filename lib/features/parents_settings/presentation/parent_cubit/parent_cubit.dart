import 'package:IOT_SmartHome/features/parents_settings/presentation/parent_cubit/parent_state.dart';
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

  void _initializeNotifications() {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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

  Stream<int> getTotalDevicesCount(String familyId) {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getActiveRequestsCount(String familyId) {
    return _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: familyId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

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

  Future<void> toggleDeviceStatus(String deviceId, bool status) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({'status': status});
      emit(DeviceStatusUpdated());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      await _firestore.collection('devices').doc(deviceId).delete();
      emit(DeviceDeletedSuccess());
    } catch (e) {
      emit(DeviceOperationFailure(error: e.toString()));
    }
  }

  Future<void> approveRequest(String requestId) async {
    try {
      final requestDoc = await _firestore.collection('otp_requests').doc(requestId).get();
      if (!requestDoc.exists) throw Exception('Request not found');
      final requestData = requestDoc.data() as Map<String, dynamic>;
      final deviceId = requestData['deviceId'] as String;

      final batch = _firestore.batch();
      final requestRef = _firestore.collection('otp_requests').doc(requestId);
      batch.update(requestRef, {
        'status': 'approved',
        'approvedTimestamp': FieldValue.serverTimestamp(),
      });

      final deviceRef = _firestore.collection('devices').doc(deviceId);
      batch.update(deviceRef, {
        'status': true,
        'lastUsed': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      emit(OTPRequestApproved());
    } catch (e) {
      emit(DeviceOperationFailure(error: 'Approve failed: ${e.toString()}'));
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      final requestDoc = await _firestore.collection('otp_requests').doc(requestId).get();
      if (!requestDoc.exists) throw Exception('Request not found');
      final requestData = requestDoc.data() as Map<String, dynamic>;
      final deviceId = requestData['deviceId'] as String;

      final batch = _firestore.batch();
      final requestRef = _firestore.collection('otp_requests').doc(requestId);
      batch.update(requestRef, {
        'status': 'rejected',
        'rejectedTimestamp': FieldValue.serverTimestamp(),
      });

      final deviceRef = _firestore.collection('devices').doc(deviceId);
      batch.update(deviceRef, {
        'status': false,
        'lastUsed': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      emit(OTPRequestRejected());
    } catch (e) {
      emit(DeviceOperationFailure(error: 'Reject failed: ${e.toString()}'));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOtpRequests(String familyId) {
    return _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: familyId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }
}