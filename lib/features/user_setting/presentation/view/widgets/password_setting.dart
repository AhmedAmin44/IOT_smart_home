import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/widgets/custom_check_box.dart';

class PasswordSetting extends StatelessWidget {
  final bool isAdmin;
  const PasswordSetting({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordGenerateCubit, PasswordGenerateState>(
      builder: (context, state) {
        return Column(
          spacing: 15,
          children: [
            Text(
              "Password Setting",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.offWhite),
            ),
            Row(children: [
              Expanded(
                  child: Column(
                children: [
                  CustomCheckBox(
                    label: 'lowerCase (a-z)',
                    value: state.isLowerCase,
                    onChanged: isAdmin ? () => context.read<PasswordGenerateCubit>().toggleLowerCase() : () {},
                  ),
                  CustomCheckBox(
                    label: 'Numbers (0-9)',
                    value: state.isNumbers,
                    onChanged: isAdmin ? () => context.read<PasswordGenerateCubit>().toggleNumbers() : () {},
                  ),
                  CustomCheckBox(
                    label: 'Exclude Duplicate',
                    value: state.isExcludeDuplicate,
                    onChanged: isAdmin ? () => context.read<PasswordGenerateCubit>().toggleExcludeDuplicate() : () {},
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  CustomCheckBox(
                    label: 'UpperCase (A-Z)',
                    value: state.isUpperCase,
                    onChanged: isAdmin ? () => context.read<PasswordGenerateCubit>().toggleUpperCase() : () {},
                  ),
                  CustomCheckBox(
                    label: 'Symbols (@-!-_#)',
                    value: state.isSymbols,
                    onChanged: isAdmin ? () => context.read<PasswordGenerateCubit>().toggleSymbols() : () {},
                  ),
                  CustomCheckBox(
                    label: 'Include Space',
                    value: state.isIncludeSpaces,
                    onChanged: isAdmin ? () => context.read<PasswordGenerateCubit>().toggleIncludeSpaces() : () {},
                  )
                ],
              ))
            ]),
            SizedBox(height: 8,)
          ],
          
        );
      },
    );
  }
}
