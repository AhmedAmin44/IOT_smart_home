import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback? onChanged; // Make onChanged nullable
  const CustomCheckBox(
      {super.key,
      required this.label,
      required this.value,
      this.onChanged}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: onChanged,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2, color: AppColors.prColor.withOpacity(0.25)),
              borderRadius: BorderRadius.circular(16)),
          child: Wrap(
            children: [
              SizedBox(width: 8),
              Icon(
                value ? Icons.check_box : Icons.check_box_outline_blank,
                size: Theme.of(context).textTheme.titleLarge!.fontSize,
               color: value ? Colors.blueGrey : Colors.black,
              ),
              SizedBox(width: 8),
              Text(label,style:Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.offWhite))
            ],
          ),
        ),
      ),
    );
  }
}
