import 'package:IOT_SmartHome/features/user_setting/data/local/password_generate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/features/user_setting/data/password_repo_imp.dart';
import 'package:IOT_SmartHome/features/user_setting/domain/use_cases/password_use_case.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/setting_view.dart';

class SettingGeneratePassword extends StatelessWidget {
  final bool isAdmin;
  const SettingGeneratePassword({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        try {
          return PasswordGenerateCubit(
            PasswordUseCase(PasswordRepoImp(PasswordGenerate())),
          );
        } catch (e) {
          print('Error initializing cubit: $e');
          rethrow;
        }
      },
      child: SettingView(isAdmin: isAdmin),
    );
  }
}



