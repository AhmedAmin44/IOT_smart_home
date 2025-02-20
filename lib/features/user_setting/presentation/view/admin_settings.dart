import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordCubit = context.read<PasswordGenerateCubit>();

    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Save Settings Button
          CustomBotton(
            color: const Color.fromARGB(255, 75, 112, 108),
            text: "Save Settings",
            onPressed: () async {
              await passwordCubit.saveSettings();
              ShowToast('Settings saved successfully');
            },
          ),
          SizedBox(height: 10),

        ],
      ),
    );
  }
}
