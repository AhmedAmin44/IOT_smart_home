import 'package:IOT_SmartHome/core/utils/app_images.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/app_text_style.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 45),
      color: AppColors.prColor,
      height: 270,
      width: 375,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SignInImage(),
          Text(
            AppStrings.appName,
            style: CustomTextStyles.saira700style32.copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class SignInImage extends StatelessWidget {
  const SignInImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Image.asset(AppImages.signInSmartHome),
    );
  }
}
