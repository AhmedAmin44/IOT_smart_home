import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_text_style.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text("${text} \n",
          style: CustomTextStyles.poppins600style28
              .copyWith(color: const Color.fromARGB(255, 212, 206, 206))),
    );
  }
}
