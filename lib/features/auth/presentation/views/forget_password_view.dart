
import 'package:flutter/material.dart';

import 'package:IOT_SmartHome/core/function/navigation.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_string.dart';
import 'package:IOT_SmartHome/features/auth/widgets/welcome_text.dart';

import '../../widgets/custom_forgetPassword_form.dart';
import '../../widgets/forget_password_image.dart';
import '../../widgets/forget_password_subtitle.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => customNavigateReplacement(context, "/login"),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.prColor),
        ),),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height:108 ,),
          ),
          SliverToBoxAdapter(
            child:WelcomeWidget(text: AppStrings.forgotPassword),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height:40 ,),
          ),
          SliverToBoxAdapter(
            child: ForgetPasswordImage(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height:24 ,),
          ),
          SliverToBoxAdapter(
            child: ForgetPasswordSubTitle(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height:41 ,),
          ),

          SliverToBoxAdapter(
            child:CustomForgotPasswordForm() ,
          ),
          SliverToBoxAdapter(
            child: SizedBox(height:20 ,),
          ),


        ],
      ),
    );
  }
}

