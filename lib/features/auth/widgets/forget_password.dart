import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/function/navigation.dart';

import '../../../core/utils/app_string.dart';
import '../../../core/utils/app_text_style.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        customNavigateReplacement(context, "/forgetPassword");
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          AppStrings.forgotPassword,
          style: CustomTextStyles.poppins600style28.copyWith(
              fontSize: 12, color: const Color.fromARGB(255, 190, 53, 43)),
        ),
      ),
    );
  }
}
