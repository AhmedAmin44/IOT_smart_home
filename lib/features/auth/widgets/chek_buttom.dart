import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_cubit.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/app_text_style.dart';

class TermsAndConditionWidget extends StatelessWidget {
  const TermsAndConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomChekBox(),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: AppStrings.iHaveAgreeToOur,
              style: CustomTextStyles.poppins400style12),
          TextSpan(
              text: AppStrings.termsAndCondition,
              style: CustomTextStyles.poppins400style12
                  .copyWith(decoration: TextDecoration.underline))
        ]))
      ],
    );
  }
}

class CustomChekBox extends StatefulWidget {
  const CustomChekBox({super.key});

  @override
  State<CustomChekBox> createState() => _CustomChekBoxState();
}

class _CustomChekBoxState extends State<CustomChekBox> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: value,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: AppColors.grey),
        onChanged: (newValue) {
          setState(() {
            value = newValue!;
            BlocProvider.of<AuthCubit>(context)
                .updateTermsAndConditionsChekBox(newValue: newValue);
          });
        });
  }
}
