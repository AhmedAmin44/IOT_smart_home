import 'dart:async';

import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';

class CountdownProgressBar extends StatefulWidget {
  final int remainingTime;
  final Color color;
  final VoidCallback onComplete;
  const CountdownProgressBar({
    super.key,
    required this.remainingTime,
    required this.color,
    required this.onComplete,
  });

  @override
  _CountdownProgressBarState createState() => _CountdownProgressBarState();
}

class _CountdownProgressBarState extends State<CountdownProgressBar> {
  late int remainingTime;
  late int totalTime;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.remainingTime;
    totalTime = widget.remainingTime;
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime <= 0) {
        timer.cancel();
        widget.onComplete();
      } else {
        setState(() {
          remainingTime -= 1000;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = remainingTime / totalTime;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          backgroundColor: const Color.fromARGB(255, 187, 67, 67),
          color: widget.color,
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              'Time remaining:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.prColor),
            ),
            Text(
          ' ${_formatDuration(Duration(milliseconds: remainingTime))}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.offWhite),
        ),
          ],
        ),
      ],
    );
  }
//To 
  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return 'Days:${days}d ,\n Hours:${hours}h ,\n Minutes:${minutes}m ,\nand Seconds${seconds}s';
  }
}

