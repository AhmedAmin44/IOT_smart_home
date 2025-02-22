import 'dart:async';
import 'package:flutter/material.dart';

class OTPDisplayScreen extends StatefulWidget {
  final String otpCode;
  const OTPDisplayScreen({Key? key, required this.otpCode}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Display')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.otpCode,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Expires in ${formatTime(secondsRemaining)}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("OTP request cancelled");
                Navigator.pop(context);
              },
              child: const Text('Cancel Request'),
            ),
            const SizedBox(height: 20),
            const Text('Waiting for approval...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
