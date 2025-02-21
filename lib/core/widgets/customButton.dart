import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomBotton extends StatelessWidget {
  const CustomBotton(
      {Key? key, this.color, required this.text, required this.onPressed})
      : super(key: key);
  final Color? color;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: color ?? AppColors.prColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(
            text,
            style: CustomTextStyles.poppins500style24
                .copyWith(fontSize: 18, color: AppColors.offWhite),
          )),
    );
  }
}
