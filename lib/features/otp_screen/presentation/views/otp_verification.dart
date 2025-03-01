import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/features/otp_screen/presentation/otp_cubit/otp_cubit.dart';
import 'package:IOT_SmartHome/features/otp_screen/presentation/widgets/otp_field.dart';

class OtpScreen extends StatefulWidget {
  final String successRoute; // Route name to navigate after success

  const OtpScreen({super.key, required this.successRoute});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<OtpCubit>().sendOTP();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) async {
          if (state is OTPVerified) {
            if (widget.successRoute == "verifyForPassword") {
              Navigator.pop(context, true);
            } else if (widget.successRoute == "fromLogin") {
              String role = await _fetchUserRole();
              context.go("/homeNavBar", extra: role);
            } else {
              // 🔹 Otherwise, navigate normally
              context.go(widget.successRoute);
            }
          } else if (state is OTPFailed) {
            ShowToast("Invalid OTP");
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.dialpad_rounded,
                        size: 50, color: AppColors.prColor),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter Your OTP",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OtpField(otpController: otp1Controller),
                        OtpField(otpController: otp2Controller),
                        OtpField(otpController: otp3Controller),
                        OtpField(otpController: otp4Controller),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        String otp = otp1Controller.text +
                            otp2Controller.text +
                            otp3Controller.text +
                            otp4Controller.text;
                        context.read<OtpCubit>().verifyOTP(otp);
                      },
                      child: Text(
                        "Verify OTP",
                        style:
                            TextStyle(fontSize: 18, color: AppColors.prColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Didn't receive a code?",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<OtpCubit>().sendOTP();
                      },
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Fetch user role from Firestore after OTP is verified
  Future<String> _fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'user';

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return 'father';

    return userDoc['role'] ?? 'father';
  }
}
