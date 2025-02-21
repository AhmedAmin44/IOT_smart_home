
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:IOT_SmartHome/core/database/cache/cache_helper.dart';
import 'package:IOT_SmartHome/core/function/navigation.dart';
import 'package:IOT_SmartHome/core/serveces/service_locator.dart';
import 'package:IOT_SmartHome/core/utils/app_string.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    bool isUserVisited =
        getIt<CacheHelper>().getData(key: "isUserVisited") ?? false;
    if (isUserVisited == true) {
      FirebaseAuth.instance.currentUser == null
          ? customDelay(context, "/login")
          : customDelay(context, "/home");
    } else {
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
