import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:password_gen/core/function/custom_troast.dart';
import 'package:password_gen/core/utils/app_colors.dart';
import 'package:password_gen/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:password_gen/features/auth/presentation/auth_cubit/auth_state.dart';
import 'package:password_gen/features/auth/widgets/text_form_field.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/widgets/customButton.dart';
import 'forget_password.dart';

class CustomSignInForm extends StatelessWidget {
  const CustomSignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is SignInSuccessState|| state is OTPSentState) {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null && user.emailVerified) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go("/otp_verification", extra: "fromLogin");
            });
          } else {
            ShowToast("Please verify your email before proceeding.");
            await user?.sendEmailVerification();
          }
        } else if (state is SignInFailureState) {
          ShowToast(state.errMsg);
        }
      },
      builder: (context, state) {
        return Form(
          key: authCubit.signInFormKey,
          child: Column(
            children: [
              TextFField(
                labelText: AppStrings.emailAddress,
                onChanged: (emailAddress) {
                  authCubit.emailAddress = emailAddress ?? '';
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
                  authCubit.password = password ?? '';
                },
              ),
              SizedBox(
                height: 16,
              ),
              ForgetPassword(),
              SizedBox(
                height: 88,
              ),
              state is SignInLoadingState
                  ? CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )
                  : CustomBotton(
                      onPressed: () {
                        if (authCubit.signInFormKey.currentState!.validate()) {
                          authCubit.signInWithEmailAndPassword();
                        }
                      },
                      text: AppStrings.signIn,
                    ),
            ],
          ),
        );
      },
    );
  }
}

void _navigateBasedOnRole(BuildContext context, String role) {
  context.go("/homeNavBar", extra: role);
}
