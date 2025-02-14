import 'package:flutter/cupertino.dart';
import 'package:iot_smart_home_secure/core/utils/app_images.dart';

class SignInImage extends StatelessWidget {
  const SignInImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Image.asset(Images.signInSmartHome),
    );
  }
}
