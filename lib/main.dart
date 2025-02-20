import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_gen/core/database/cache/cache_helper.dart';
import 'package:password_gen/core/serveces/service_locator.dart';
import 'package:password_gen/core/utils/app_colors.dart';
import 'package:password_gen/firebase_options.dart';
import 'package:password_gen/routers.dart';
import 'package:screenutil_module/main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if it's not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      // name: 'passwordGen',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  setupServiceLocator();
  await getIt<CacheHelper>().init();
  runApp(DevicePreview(
      enabled: !kReleaseMode, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: ThemeData(scaffoldBackgroundColor: AppColors.bgColor),
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        });
  }
}
