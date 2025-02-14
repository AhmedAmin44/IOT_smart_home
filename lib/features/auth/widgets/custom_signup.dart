
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart%20%20';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_smart_home_secure/core/function/custom_troast.dart';
import 'package:iot_smart_home_secure/core/utils/app_colors.dart';
import 'package:iot_smart_home_secure/core/widgets/customButton.dart';
import 'package:iot_smart_home_secure/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:iot_smart_home_secure/features/auth/presentation/auth_cubit/auth_state.dart';
import 'package:iot_smart_home_secure/features/auth/widgets/text_form_field.dart';

import '../../../core/function/navigation.dart';
import '../../../core/utils/app_string.dart';
import 'chek_buttom.dart';

class CustomSignUpForm extends StatelessWidget {
  const CustomSignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(
        listener: (Context, state) {
          if(state is SignUpSuccessState){
            ShowToast("Successfuly, Chek Your Email To Verify Account");
            customNavigateReplacement(context, "/login");
          }else if(state is SignUpFailureState){
            ShowToast(state.errmsg);
          }
        },
        builder: (Context, state) {
          return Form(
              key:authCubit.signUpFormKey,
              child: Column(
                children: [
                  TextFField(
                    labelText: AppStrings.fristName,
                    onChanged: (firstName) {
                      authCubit.
                      firstName
                      =
                      firstName;
                    },
                  ),
                  TextFField(
                    labelText: AppStrings.lastName,
                    onChanged: (lastName) {
                      authCubit
                          .lastName = lastName;
                    },
                  ),
                  TextFField(
                    labelText: AppStrings.emailAddress,
                    onChanged: (emailAddress) {
                      authCubit
                          .emailAddress =
                          emailAddress;
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
                  TermsAndConditionWidget(),
                  SizedBox(
                    height: 88,
                  ),
                  state is SignUpLoadingState?CircularProgressIndicator(color: AppColors.primaryColor,):
                  CustomBotton(
                    color: authCubit.termsAndConditionsChekBox==false?AppColors.grey:null,
                    onPressed: () {
                      if (authCubit.termsAndConditionsChekBox==true) {
                        if (authCubit.signUpFormKey.currentState!.validate()) {
                          authCubit.signUpWithEmailAndPassword();
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
