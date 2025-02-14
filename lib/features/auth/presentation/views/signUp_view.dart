import 'package:flutter/material.dart%20%20';
import '../../../../core/function/navigation.dart';
import '../../../../core/utils/app_string.dart';
import '../../widgets/check_account_text.dart';
import '../../widgets/custom_signup.dart';
import '../../widgets/welcome_text.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
                child: SizedBox(
              height: 152,
            )),
            SliverToBoxAdapter(
              child: WelcomeWidget(text: AppStrings.welcome),
            ),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 16,
            )),
            SliverToBoxAdapter(child: CustomSignUpForm()),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 16,
            )),
            SliverToBoxAdapter(
                child: HaveAccountWidget(
              text1: AppStrings.alreadyHaveAnAccount,
              text2: AppStrings.signIn,
              onTap: () {
                customNavigateReplacement(context, "/login");
              },
            )),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 9,
            )),
          ],
        ),
      ),
    );
  }
}
