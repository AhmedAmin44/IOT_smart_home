import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';

class PasswordButton extends StatelessWidget {
  final bool isDisabled;
  const PasswordButton({super.key, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled
          ? null
          : () => context.read<PasswordGenerateCubit>().generatePassword(),
      child: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient:
                LinearGradient(colors: [AppColors.prColor, AppColors.bgColor]),
            boxShadow: [
              BoxShadow(
                  color: AppColors.prColor,
                  offset: Offset(-2, 0),
                  blurRadius: 3,
                  spreadRadius: 1)
            ],
            color: isDisabled ? Colors.grey : null),
        child: Center(
            child: Text(
          "Generate Password",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold, color: AppColors.offWhite),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
