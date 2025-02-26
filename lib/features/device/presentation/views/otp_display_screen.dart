import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../device_cubit/device_cubit.dart';

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
  int _secondsRemaining = 600;
  Timer? _countdownTimer;
  bool _hasNavigated = false;
  StreamSubscription? _otpSubscription;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _listenForStatusUpdates();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _cancelRequestAndClose();
        timer.cancel();
      }
    });
  }

  void _listenForStatusUpdates() {
    _otpSubscription = FirebaseFirestore.instance
        .collection('otp_requests')
        .doc(widget.otpRequestId)
        .snapshots()
        .listen((snapshot) async {
      final data = snapshot.data();
      // Proceed only if data exists, the widget hasn't already navigated, and is still mounted.
      if (data == null || _hasNavigated || !mounted) return;
      
      // Check if either approvedTimestamp or rejectedTimestamp is present
      if (data.containsKey('approvedTimestamp') || data.containsKey('rejectedTimestamp')) {
        _hasNavigated = true;
        if (data.containsKey('approvedTimestamp')) {
          await context.read<DeviceCubit>().updateDeviceStatus(context, widget.deviceId, true);
        }
        if (data['status'] != 'completed') {
          await FirebaseFirestore.instance
              .collection('otp_requests')
              .doc(widget.otpRequestId)
              .update({'status': 'completed'});
        }
        Navigator.pop(context);
      }
    });
  }

  Future<void> _cancelRequestAndClose() async {
    if (!_hasNavigated && mounted) {
      final doc = await FirebaseFirestore.instance
          .collection('otp_requests')
          .doc(widget.otpRequestId)
          .get();
      if (doc.exists && doc['status'] == 'pending') {
        await doc.reference.delete();
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpSubscription?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Code: ${widget.otpCode}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(_secondsRemaining),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cancelRequestAndClose,
              child: const Text('Cancel Request'),
            ),
          ],
        ),
      ),
    );
  }
}
