import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';

class PasswordLeangth extends StatelessWidget {
  final bool isAdmin;
  const PasswordLeangth({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordGenerateCubit, PasswordGenerateState>(
      builder: (context, state) {
        double minLength = 8.0;
        double maxLength = state.maxPasswordLength.toDouble();
        double passwordLength = state.passwordLength.toDouble();

        if (maxLength < minLength) {
          maxLength = minLength;
        }
        if (passwordLength < minLength) {
          passwordLength = minLength;
        }

        return Column(
          spacing: 20,
          children: [
            Text(
              "Password Length",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.offWhite, fontSize: 30),
            ),
            if (!isAdmin) 
              Text(
                "This is controlled by admins only",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.red, fontSize: 12),
              ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTickMarkColor: Colors.blue,
                inactiveTickMarkColor: Colors.blue,
                thumbColor: AppColors.prColor,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 1),
              ),
              child: Material(
                color: const Color.fromARGB(0, 75, 63, 146),
                child: Slider(
                    min: minLength,
                    max: maxLength,
                    value: passwordLength,
                    onChanged: isAdmin
                        ? (value) => context
                            .read<PasswordGenerateCubit>()
                            .changePasswordLength(value.toInt())
                        : null),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    // ignore: deprecated_member_use
                    width: 2, color: AppColors.prColor.withOpacity(0.25)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  state.passwordLength.toString(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.offWhite),
                ),
              ),
            ),
            SizedBox(height: 5,)
          ],
        );
      },
    );
  }
}
