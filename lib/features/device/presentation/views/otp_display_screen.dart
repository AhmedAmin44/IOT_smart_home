import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OTPDisplayScreen extends StatefulWidget {
  final String otpCode;
  final String role;
  final String familyId;
  final String deviceId;
  final String deviceName;
  final String otpRequestId; 

  const OTPDisplayScreen({
    Key? key,
    required this.otpCode,
    required this.role,
    required this.familyId,
    required this.deviceId,
    required this.deviceName,
    required this.otpRequestId,
  }) : super(key: key);

  @override
  _OTPDisplayScreenState createState() => _OTPDisplayScreenState();
}

class _OTPDisplayScreenState extends State<OTPDisplayScreen> {
  int secondsRemaining = 600; 
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _otpRequestStream() {
    return FirebaseFirestore.instance
        .collection('otp_requests')
        .doc(widget.otpRequestId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Display'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _otpRequestStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final requestData = snapshot.data!.data();
          String status = requestData?['status'] ?? 'pending';

          if (status == 'approved') {
            Future.microtask(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request Approved.')),
              );
              Navigator.pop(context); // الخروج من شاشة OTP، أو التنقل إلى شاشة التحكم
            });
          } else if (status == 'rejected') {
            Future.microtask(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request Rejected.')),
              );
              Navigator.pop(context);
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.otpCode,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Expires in ${formatTime(secondsRemaining)}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel Request'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Waiting for approval...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
