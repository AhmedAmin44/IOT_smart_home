import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_string.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GradientText(
        textAlign: TextAlign.center,
        AppStrings.appName,
        style: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(fontWeight: FontWeight.bold,fontSize: 45),
        gradientType: GradientType.linear,
        gradientDirection: GradientDirection.ttb,
        radius: 1,
        colors: [AppColors.prColor, AppColors.offWhite],
      ),
    );
  }
}
