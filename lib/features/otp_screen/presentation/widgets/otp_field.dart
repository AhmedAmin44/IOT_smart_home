import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.otpController,
  });

  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.prColor,
            ),
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: '-',
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
