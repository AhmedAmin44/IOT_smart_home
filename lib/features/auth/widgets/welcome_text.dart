import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_text_style.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(text,
          style:CustomTextStyles.poppins600style28.copyWith(color:  Colors.white)),
    );
  }
}