import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:IOT_SmartHome/features/auth/presentation/views/forget_password_view.dart';
import 'package:IOT_SmartHome/features/auth/presentation/views/signIn_view.dart';
import 'package:IOT_SmartHome/features/auth/presentation/views/signUp_view.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_nav_bar.dart';
import 'package:IOT_SmartHome/features/splash/view/splash_view.dart';

import 'features/home/presentation/views/home_view.dart';
import 'features/family_setup/presentation/family_setup_screen.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: "/family-setup",
    builder: (context, state) {
      final extra = state.extra as Map?;
      if (extra == null) {
        return const Scaffold(
          body: Center(child: Text('Error: Missing role or family ID')),
        );
      }
      final role = extra['role'] as String;
      final familyId = extra['familyId'] as String;
      return BlocProvider(
        create: (context) => AuthCubit(),
        child: FamilySetupScreen(role: role, familyId: familyId),
      );
    },
  ),
  GoRoute(
    path: "/signUp",
    builder: (context, state) =>
        BlocProvider(create: (context) => AuthCubit(), child: SignUpView()),
  ), 
  GoRoute(
    path: "/login",
    builder: (context, state) =>
        BlocProvider(create: (context) => AuthCubit(), child: LoginView()),
  ),
  GoRoute(
    path: "/forgetPassword",
    builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(), child: ForgetPasswordView()),
  ),
  GoRoute(
    path: "/homeNavBar",
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      if (extra == null) {
        return const Scaffold(
          body: Center(child: Text('Error: Missing role or family ID')),
        );
      }
      final role = extra['role'] as String;
      final familyId = extra['familyId'] as String;
      return HomeNavBarWidget(role: role, familyId: familyId);
    },
  ),
  GoRoute(
    path: "/home",
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      if (extra == null) {
        return const Scaffold(
          body: Center(child: Text('Error: Missing role or family ID')),
        );
      }
      final role = extra['role'] as String? ?? 'user';
      final familyId = extra['familyId'] as String;
      return HomeView(role: role, familyId: familyId);
    },
  ),
]);
