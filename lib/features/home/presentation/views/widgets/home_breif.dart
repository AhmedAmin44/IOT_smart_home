import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_string.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:screenutil_module/main.dart';

class HomeBreif extends StatelessWidget {
  final String role;

  const HomeBreif({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      width: 250.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role == 'father'
                ? AppStrings.homeAdminBrief
                : AppStrings.homeUserBrief,
            style: CustomTextStyles.poppins300style16,
          ),
          SizedBox(height: 10.h),
          Flexible(
            child: Text(
              role == 'father'
                  ? AppStrings.homeAdminBriefContent
                  : AppStrings.homeUserBriefContent,
              style: TextStyle(color: AppColors.prColor, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}
