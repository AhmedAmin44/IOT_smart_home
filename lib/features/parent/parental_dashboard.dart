import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ParentalDashboard extends StatefulWidget {
  final String familyId;

  const ParentalDashboard({Key? key, required this.familyId}) : super(key: key);

  @override
  _ParentalDashboardState createState() => _ParentalDashboardState();
}

class _ParentalDashboardState extends State<ParentalDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForNewOTPRequests();
  }

  // Initialize local notifications for Android & iOS.
  void _initializeNotifications() {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings();
    final initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Listen for new OTP requests and show a local notification.
  void _listenForNewOTPRequests() {
    _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: widget.familyId)
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

    final androidDetails = AndroidNotificationDetails(
      'otp_channel',
      'OTP Requests',
      channelDescription: 'Notifications for OTP requests',
      importance: Importance.max,
      priority: Priority.high,
    );
    final iosDetails = DarwinNotificationDetails();
    final notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New OTP Request',
      'Child requested OTP for $deviceName. OTP: $otp',
      notificationDetails,
      payload: 'otp_request',
    );
  }

  // Approve the OTP request by updating its status in Firestore.
  Future<void> _approveRequest(String requestId) async {
    try {
      await _firestore.collection('otp_requests').doc(requestId).update({
        'status': 'approved',
        'approvedTimestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Request approved.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error approving request: $e')));
    }
  }

  // Reject the OTP request by updating its status in Firestore.
  Future<void> _rejectRequest(String requestId) async {
    try {
      await _firestore.collection('otp_requests').doc(requestId).update({
        'status': 'rejected',
        'rejectedTimestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Request rejected.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error rejecting request: $e')));
    }
  }

  // Stream for total devices count.
  Stream<int> _getTotalDevicesCount() {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: widget.familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream for active OTP requests count.
  Stream<int> _getActiveRequestsCount() {
    return _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: widget.familyId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream for pending OTP requests.
  Stream<QuerySnapshot<Map<String, dynamic>>> _otpRequestsStream() {
    return _firestore
        .collection('otp_requests')
        .where('familyId', isEqualTo: widget.familyId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parental Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display real data: Total Devices & Active Requests.
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder<int>(
                        stream: _getTotalDevicesCount(),
                        builder: (context, snapshot) {
                          int totalDevices = snapshot.data ?? 0;
                          return Column(
                            children: [
                              Text('Total Devices',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text(totalDevices.toString(),
                                  style: TextStyle(fontSize: 24)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StreamBuilder<int>(
                        stream: _getActiveRequestsCount(),
                        builder: (context, snapshot) {
                          int activeRequests = snapshot.data ?? 0;
                          return Column(
                            children: [
                              Text('Active Requests',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text(activeRequests.toString(),
                                  style: TextStyle(fontSize: 24)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // List of pending OTP requests with Approve/Reject actions.
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _otpRequestsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No pending requests.'));
                  }
                  final requests = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final requestData = requests[index].data();
                      final requestId = requests[index].id;
                      final deviceName = requestData['deviceName'] ?? '';
                      final otp = requestData['otp'] ?? '';
                      final timestamp = requestData['timestamp'] != null
                          ? (requestData['timestamp'] as Timestamp).toDate()
                          : null;
                      final formattedTime = timestamp != null
                          ? '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}'
                          : 'N/A';
                      return Card(
                        child: ListTile(
                          title: Text('Device: $deviceName'),
                          subtitle: Text('OTP: $otp\nTime: $formattedTime'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  _approveRequest(requestId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  _rejectRequest(requestId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Optional: Button for quick access to device controls.
            ElevatedButton(
              onPressed: () {
                print("Quick access to device controls pressed");
              },
              child: Text('Device Controls'),
            ),
          ],
        ),
      ),
    );
  }
}
