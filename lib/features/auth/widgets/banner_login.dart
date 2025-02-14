import 'package:flutter/cupertino.dart';
import 'package:iot_smart_home_secure/features/auth/widgets/sign_in_image.dart';

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
          Text(AppStrings.appName ,style: CustomTextStyles.saira700style32.copyWith(fontSize: 30),),
        ],
      ),
    );
  }
}
