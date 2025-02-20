import 'package:flutter/cupertino.dart';
import 'package:IOT_SmartHome/core/utils/app_images.dart';

class ForgetPasswordImage extends StatelessWidget {
  const ForgetPasswordImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      width: 235,
      child: Image.asset(AppImages.forgot_password),
    );
  }
}
