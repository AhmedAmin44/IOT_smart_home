import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_state.dart';
import 'package:IOT_SmartHome/features/auth/widgets/text_form_field.dart';
import 'package:IOT_SmartHome/features/otp_screen/presentation/otp_cubit/otp_cubit.dart';

import '../../../core/utils/app_string.dart';
import 'chek_buttom.dart';

class CustomSignUpForm extends StatelessWidget {
  const CustomSignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(listener: (Context, state) {
      if (state is SignUpSuccessState || state is OTPSent) {
        ShowToast(
            "Successfully registered! Check your email for OTP verification.");
        context.go("/otp_verification", extra: "/login");
      } else if (state is SignUpFailureState) {
        ShowToast(state.errmsg);
      }
    }, builder: (Context, state) {
      return Form(
          key: authCubit.signUpFormKey,
          child: Column(
            children: [
              TextFField(
                labelText: AppStrings.fristName,
                onChanged: (firstName) {
                  authCubit.firstName = firstName;
                },
              ),
              TextFField(
                labelText: AppStrings.lastName,
                onChanged: (lastName) {
                  authCubit.lastName = lastName;
                },
              ),
              TextFField(
                labelText: AppStrings.emailAddress,
                onChanged: (emailAddress) {
                  authCubit.emailAddress = emailAddress;
                },
              ),
              TextFField(
                labelText: AppStrings.phone,
                onChanged: (phone) {
                  authCubit.phone = phone;
                },
              ),
              TextFField(
                labelText: AppStrings.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    authCubit.obscurePasswordTextValue == true
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    authCubit.obscurePasswordText();
                  },
                ),
                obscureText: authCubit.obscurePasswordTextValue,
                onChanged: (password) {
                  authCubit.password = password;
                },
              ),
              // Add the "Verify Password" field
              TextFField(
                labelText: "Verify Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    authCubit.obscureVerifyPasswordTextValue == true
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    authCubit.obscureVerifyPasswordText();
                  },
                ),
                obscureText: authCubit.obscureVerifyPasswordTextValue,
                onChanged: (verifyPassword) {
                  authCubit.verifyPassword = verifyPassword;
                },
              ),
              TermsAndConditionWidget(),
              SizedBox(
                height: 88,
              ),
              state is SignUpLoadingState
                  ? CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )
                  : CustomBotton(
                      color: authCubit.termsAndConditionsChekBox == false
                          ? AppColors.grey
                          : null,
                      onPressed: () async {
                        if (authCubit.termsAndConditionsChekBox!) {
                          if (authCubit.signUpFormKey.currentState!
                              .validate()) {
                            // Check if password and verify password match
                            if (authCubit.password !=
                                authCubit.verifyPassword) {
                              ShowToast("Passwords do not match.");
                            } else {
                              await authCubit.signUpWithEmailAndPassword();
                            }
                          }
                        }
                      },
                      text: AppStrings.signUp,
                    ),
            ],
          ));
    });
  }
}
