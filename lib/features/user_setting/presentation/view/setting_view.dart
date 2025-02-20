import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/admin_settings.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/copy_result_container.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/countdown_progress_bar.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/header.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/password_button.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/password_leangth.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/password_setting.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/user_save_password_button.dart';

import '../../../home/presentation/views/widgets/home_nav_bar.dart';

class SettingView extends StatelessWidget {
  final bool isAdmin;
  const SettingView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return isAdmin
        ? _buildSettingsView(context)
        : FutureBuilder<int>(
            future: _getRemainingTimeFromFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading time'));
              }
              if (snapshot.data != null && snapshot.data! > 0) {
                context.read<PasswordGenerateCubit>().updateRemainingTime(snapshot.data!);
                return _buildHomeWithTimer(context, snapshot.data!);
              }
              return _buildSettingsView(context);
            },
          );
  }

  Future<int> _getRemainingTimeFromFirebase() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 0;

  final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (!userDoc.exists) return 0;

  final lastTime = userDoc.data()?['lastPasswordGenerationTime'] ?? 0;
  final currentTime = DateTime.now().millisecondsSinceEpoch;
  const duration = 4 * 24 * 60 * 60 * 1000; // 4 days in milliseconds

  return (duration - (currentTime - lastTime)).clamp(0, duration).toInt();
}


  Widget _buildHomeWithTimer(BuildContext context, int remainingTime) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You can not access the settings yet,\nPlease wait until the timer ends.',
                style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CountdownProgressBar(
                remainingTime: remainingTime,
                color: Colors.white,
                onComplete: () => context.go('/setting'),
              ),
              const SizedBox(height: 20),
              CustomBotton(
                text: 'Back to home!',
                color: const Color.fromARGB(255, 75, 112, 108),
                onPressed: () => _navigateToHome(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    final homeNavBarWidget = context.findAncestorWidgetOfExactType<HomeNavBarWidget>();

    if (homeNavBarWidget != null) {
      homeNavBarWidget.controller.jumpToTab(0);
    } else {
      context.go('/homeNavBar');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.findAncestorWidgetOfExactType<HomeNavBarWidget>()?.controller.jumpToTab(0);
      });
    }
  }

  Widget _buildSettingsView(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('settings').doc('passwordSettings').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Error loading settings'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          // Update settings using Bloc after Future completes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<PasswordGenerateCubit>().updateSettings(
                  passwordLength: data['passwordLength'] ?? 10,
                  isLowerCase: data['isLowerCase'] ?? false,
                  isUpperCase: data['isUpperCase'] ?? false,
                  isNumbers: data['isNumbers'] ?? false,
                  isSymbols: data['isSymbols'] ?? false,
                  isExcludeDuplicate: data['isExcludeDuplicate'] ?? false,
                  isIncludeSpaces: data['isIncludeSpaces'] ?? false,
                );
          });

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Header(),
                PasswordLeangth(isAdmin: isAdmin),
                PasswordSetting(isAdmin: isAdmin),
                if (isAdmin) AdminSettings(),
                if (!isAdmin) const CopyResultContainer(),
                if (!isAdmin)
                  PasswordButton(
                    isDisabled: context.watch<PasswordGenerateCubit>().state.remainingTime > 0,
                  ),
                if (!isAdmin) const UserSavePasswordButton(),
                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
