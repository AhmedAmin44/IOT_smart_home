import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iot_smart_home_secure/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:iot_smart_home_secure/features/auth/presentation/views/forget_password_view.dart';
import 'package:iot_smart_home_secure/features/auth/presentation/views/signIn_view.dart';
import 'package:iot_smart_home_secure/features/auth/presentation/views/signUp_view.dart';
import 'package:iot_smart_home_secure/features/home/presentation/views/home_view.dart';
import 'package:iot_smart_home_secure/features/splash/view/splash_view.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SplashScreen(),
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
    path: "/home",
    builder: (context, state) => HomeView(),
  ),
]
);
