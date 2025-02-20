import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';

class CopyResultContainer extends StatefulWidget {
  const CopyResultContainer({super.key});

  @override
  State<CopyResultContainer> createState() => _CopyResultContainerState();
}

class _CopyResultContainerState extends State<CopyResultContainer> {
  bool isCopy = false;
  Color borderColor = AppColors.bgColor;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordGenerateCubit, PasswordGenerateState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: borderColor,
          ),
          child: TextField(
            controller: state.passwordController,
              readOnly: true,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.prColor),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.copy,
                    color: AppColors.prColor,
                    size: Theme.of(context).textTheme.titleLarge!.fontSize,
                  )),
              onTap: () {
                Clipboard.setData(ClipboardData(text: state.passwordController.text));
                setState(() => borderColor = AppColors.prColor);
                Timer(const Duration(milliseconds: 300),
                    () => setState(() => borderColor = AppColors.bgColor));
              }),
        );
      },
    );
  }
}
