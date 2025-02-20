import 'dart:async';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/function/navigation.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OtpCubit() : super(OtpInitial());

  Future<void> sendOTP() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        emit(OTPFailed("User not found"));
        return;
      }

      EmailOTP.config(
        appEmail: "contact@PasswordGenerator.com",
        appName: "Password Generator Email OTP",
        emailTheme: EmailTheme.v3,
        otpLength: 4,
        otpType: OTPType.numeric,
      );

      if (await EmailOTP.sendOTP(email: user.email!) == true) {
        emit(OTPSent());
      } else {
        emit(OTPFailed("Failed to send OTP"));
      }
    } catch (e) {
      emit(OTPFailed("Error: ${e.toString()}"));
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      if (EmailOTP.verifyOTP(otp: otp) == true) {
        emit(OTPVerified());
      } else {
        emit(OTPFailed("Invalid OTP"));
      }
    } catch (e) {
      emit(OTPFailed("Error: ${e.toString()}"));
    }
  }

  Future<bool> waitForOTPVerification(context) async {
    Completer<bool> completer = Completer<bool>();

    StreamSubscription? subscription;
    subscription = stream.listen((state) {
      if (state is OTPVerified) {
        completer.complete(true);
        customNavigate(context, "/");
      } else if (state is OTPFailed) {
        completer.complete(false);
      }
      subscription?.cancel();
    });

    return completer.future;
  }
}
