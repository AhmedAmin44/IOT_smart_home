
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20%20';
import 'package:iot_smart_home_secure/core/database/cache/cache_helper.dart';
import 'package:iot_smart_home_secure/core/function/navigation.dart';
import 'package:iot_smart_home_secure/core/serveces/service_locator.dart';
import 'package:iot_smart_home_secure/core/utils/app_colors.dart';
import 'package:iot_smart_home_secure/core/utils/app_string.dart';
import 'package:iot_smart_home_secure/core/utils/app_text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // to get data that are saved from part of onboarding to know if user visit or not
    bool isUserVisited =
        getIt<CacheHelper>().getData(key: "isUserVisited") ?? false;
    if (isUserVisited == true) {
      // if the user visit it before go direct to SignUp ,and if ha had account go to home directly
      FirebaseAuth.instance.currentUser == null
          ? customDelay(context, "/login")
          : customDelay(context, "/home");
    } else {
      //if the user not visit it before go to onBoarding First
      customDelay(context, "/login");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppStrings.appName,
            style: CustomTextStyles.pacifico400style64.copyWith(fontSize: 30,color: AppColors.primaryColor)),
      ),
    );
  }
}

void customDelay(context, path) {
  Future.delayed(
    const Duration(seconds: 2),
    () {
      customNavigateReplacement(context, path);
    },
  );
}
