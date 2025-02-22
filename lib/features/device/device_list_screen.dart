import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'otp_display_screen.dart';

class DeviceListScreen extends StatefulWidget {
  final String familyId;
  final String role;

  const DeviceListScreen({Key? key, required this.familyId, required this.role})
      : super(key: key);

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch devices from Firestore
  Stream<List<Map<String, dynamic>>> _getDevices() {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: widget.familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc['name'],
              'status': doc['status'],
              'isDangerous': doc['isDangerous'],
              'lastUsed': doc['lastUsed']?.toDate(),
            }).toList());
  }

  // Generate a random 6-digit OTP
  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Request OTP for a dangerous device
  void _requestOTPForDangerousDevice(String deviceId, String deviceName) async {
    if (widget.role == 'child') {
      String otp = generateOTP();
          DocumentReference docRef = await _firestore.collection('otp_requests').add({
        'otp': otp,
        'childId': widget.familyId, // ideally use child's unique id
        'deviceId': deviceId,
        'deviceName': deviceName,
        'familyId': widget.familyId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending'
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPDisplayScreen(
            otpCode: otp,
            role: widget.role,
            familyId: widget.familyId,
            deviceId: deviceId,
            deviceName: deviceName,
          otpRequestId: docRef.id,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only children can request OTP.')),
      );
    }
  }

  // Update device status (for non-dangerous devices or parent's control)
  Future<void> _updateDeviceStatus(String deviceId, bool newStatus) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Device status updated successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update device status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices found'));
          }
          final devices = snapshot.data!;
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final isDangerous = device['isDangerous'] ?? false;
              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  title: Text(
                    device['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  subtitle: Text(
                    'Status: ${device['status'] ? 'On' : 'Off'}\n'
                    'Last used: ${device['lastUsed'] != null ? device['lastUsed'].toString().substring(0, 16) : 'Never'}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDangerous && widget.role == 'child')
                        IconButton(
                          icon: const Icon(Icons.lock, color: Colors.red),
                          onPressed: () {
                            _requestOTPForDangerousDevice(device['id'], device['name']);
                          },
                        ),
                      if (!isDangerous || widget.role == 'parent')
                        Switch(
                          value: device['status'],
                          activeColor: Colors.green,
                          inactiveTrackColor: Colors.grey,
                          onChanged: (val) async {
                            await _updateDeviceStatus(device['id'], val);
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
    );
  }
}
