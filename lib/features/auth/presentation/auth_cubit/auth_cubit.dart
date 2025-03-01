import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/features/otp_screen/presentation/otp_cubit/otp_cubit.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String? firstName;
  String? lastName;
  String? emailAddress;
  String? password;
  String? phone;
  String verificationId = '';
  String? otpCode;
  String? verifyPassword;

  //// 
  String? role;
  String? familyId;
  void initialize({required String familyId, required String role}) {
    this.familyId = familyId;
    this.role = role;
  }

  bool obscureVerifyPasswordTextValue = true;
  bool? termsAndConditionsCheckBox = false;
  bool? obscurePasswordTextValue = true;
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  GlobalKey<FormState> signInFormKey = GlobalKey();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OtpCubit otpCubit = OtpCubit();
//Auth Cubit 
  // Checks if there is no father account yet
  Future<bool> _isFirstUser() async {
    final result = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'father')
        .limit(1)
        .get();
    return result.docs.isEmpty;
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _emitState(AuthState state) {
    if (!isClosed) emit(state);
  }

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}

bool isValidPhone(String phone) {
  final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
  return phoneRegex.hasMatch(phone);
}

Future<void> signUpWithEmailAndPassword() async {
  try {
    _emitState(SignUpLoadingState());

    if (firstName == null ||
        lastName == null ||
        phone == null ||
        emailAddress == null ||
        password == null) {
      _emitState(SignUpFailureState(errmsg: 'Please fill all required fields'));
      return;
    }

    if (!isValidEmail(emailAddress!)) {
      _emitState(SignUpFailureState(errmsg: 'Please enter a valid email address.'));
      return;
    }
    if (!isValidPhone(phone!)) {
      _emitState(SignUpFailureState(errmsg: 'Please enter a valid phone number.'));
      return;
    }
    
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: emailAddress)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      _emitState(SignUpFailureState(errmsg: 'Email already in use'));
      return;
    }

    role = 'father';
    familyId = const Uuid().v4();

    final credential = await _auth.createUserWithEmailAndPassword(
      email: emailAddress!,
      password: password!,
    );

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': emailAddress,
      'phone': phone,
      'role': role,
      'familyId': familyId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // await _verifyPhoneNumber(phone!);

    String uid = credential.user!.uid;
    await addUserProfile(uid);
    emailAddress = await getUserEmail(uid);
      await otpCubit.sendOTP();
    await sendVerificationEmail();
    _emitState(SignUpSuccessState());
  } on FirebaseAuthException catch (e) {
    _handleSignUpException(e);
  } catch (e) {
    _emitState(SignUpFailureState(errmsg: e.toString()));
  }
}

  void _handleSignUpException(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      _emitState(SignUpFailureState(errmsg: 'The password provided is too weak.'));
    } else if (e.code == 'email-already-in-use') {
      _emitState(SignUpFailureState(errmsg: 'The account already exists for that email.'));
    } else if (e.code == 'invalid-email') {
      _emitState(SignUpFailureState(errmsg: 'The email is invalid.'));
    } else {
      _emitState(SignUpFailureState(errmsg: e.code));
    }
  }

  void obscureVerifyPasswordText() {
    obscureVerifyPasswordTextValue = !obscureVerifyPasswordTextValue;
    _emitState(AuthInitial());
  }

  Future<String?> getUserEmail(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      return userDoc['email'];
    }
    return null;
  }

  Future<void> sendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        DateTime? lastEmailSent = user.metadata.lastSignInTime;
        if (lastEmailSent != null &&
            DateTime.now().difference(lastEmailSent).inMinutes < 5) {
          ShowToast("Please wait before requesting another verification email.");
          return;
        }
        await user.sendEmailVerification();
        ShowToast("Verification email sent! Check your inbox.");
      } on FirebaseAuthException catch (e) {
        if (e.code == "too-many-requests") {
          ShowToast("Too many requests. Try again later.");
        } else {
          ShowToast("Error: ${e.message}");
        }
      }
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      _emitState(SignInLoadingState());
      if (emailAddress == null || password == null) {
        _emitState(SignInFailureState(errMsg: "Please fill all required fields"));
        return;
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailAddress!,
        password: password!,
      );
      if (userCredential.user == null) {
        _emitState(SignInFailureState(errMsg: "Authentication failed."));
        return;
      }
      User? user = _auth.currentUser;
      if (user == null) {
        _emitState(SignInFailureState(errMsg: "User not found."));
        return;
      }
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        _emitState(SignInFailureState(errMsg: "User data not found."));
        return;
      }
      role = userDoc['role'] ?? 'user';
      familyId = userDoc['familyId'];
      emailAddress = user.email;
      _emitState(SignInSuccessState(role: role!, familyId: familyId!));
    } on FirebaseAuthException catch (e) {
      _emitState(SignInFailureState(errMsg: e.message ?? "Check your email and password."));
    } catch (e) {
      _emitState(SignInFailureState(errMsg: e.toString()));
    }
  }

  Future<void> addUserProfile(String uid) async {
    await _firestore.collection("users").doc(uid).set({
      "firstname": firstName,
      "lastname": lastName,
      "email": emailAddress,
      "phone": phone,
      "familyId":familyId,
      "role": "father",
    });
  }

  String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleaned.startsWith('+')) {
      cleaned = '+20$cleaned';
    }
    return cleaned;
  }

  Future<void> resetPasswordWithLink() async {
    try {
      _emitState(ResetPasswordLoadingState());
      await _auth.sendPasswordResetEmail(email: emailAddress ?? '');
      _emitState(ResetPasswordSuccessState());
    } catch (e) {
      _emitState(ResetPasswordFailureState(errMsg: e.toString()));
    }
  }

  void updateTermsAndConditionsCheckBox({newValue}) {
    termsAndConditionsCheckBox = newValue;
    _emitState(TermsAndConditionsCheckBoxState());
  }

  void obscurePasswordText() {
    obscurePasswordTextValue = !obscurePasswordTextValue!;
    _emitState(ObscurePasswordTextUpdateState());
  }
}
class OTPSentState extends AuthState {
  final String role;
  OTPSentState({required this.role});
}