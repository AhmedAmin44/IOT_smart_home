import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/features/otp_screen/presentation/otp_cubit/otp_cubit.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

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
  String? role;
  String? familyId;

  bool obscureVerifyPasswordTextValue = true;
  bool? termsAndConditionsCheckBox = false;
  bool? obscurePasswordTextValue = true;
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  GlobalKey<FormState> signInFormKey = GlobalKey();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OtpCubit otpCubit = OtpCubit();
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
    // Perform any necessary cleanup here
    return super.close();
  }

  void _emitState(AuthState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      _emitState(SignUpLoadingState());
      final isFirstUser = await _isFirstUser();

      if (firstName == null || lastName == null || phone == null || emailAddress == null || password == null) {
        _emitState(SignUpFailureState(errmsg: 'املأ جميع الحقول المطلوبة'));
        return;
      }

      if (isFirstUser) {
        role = 'father';
        familyId = const Uuid().v4();
      } else {
        _emitState(SignUpFailureState(errmsg: 'التسجيل مسموح فقط لرب الأسرة'));
        return;
      }

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

      await _verifyPhoneNumber(phone!);
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

  Future<void> _verifyPhoneNumber(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.currentUser!.linkWithCredential(credential);
      },
      verificationFailed: (e) {
        _emitState(SignUpFailureState(errmsg: 'فشل التحقق: ${e.message}'));
      },
      codeSent: (verificationId, _) {
        this.verificationId = verificationId;
        _emitState(PhoneCodeSentState());
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> verifyPhoneOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.currentUser!.linkWithCredential(credential);
      _emitState(PhoneVerificationSuccessState());
    } catch (e) {
      _emitState(SignUpFailureState(errmsg: 'كود التحقق غير صحيح'));
    }
  }

  Future<void> sendFamilyInvite({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String password,
  }) async {
    try {
      if (role != 'father') {
        _emitState(OperationFailureState(errMsg: 'غير مصرح بهذا الإجراء'));
        return;
      }

      // Create user account in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Record the user in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': role,
        'familyId': familyId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Log the invite details
      print('User account created and recorded in Firestore for $email');

      _emitState(InviteSentSuccessState());
    } on FirebaseAuthException catch (e) {
      _emitState(OperationFailureState(errMsg: e.message ?? 'Failed to create user account'));
    } catch (e) {
      _emitState(OperationFailureState(errMsg: e.toString()));
    }
  }

  Future<void> joinFamilyWithInvite({
    required String email,
    required String password,
  }) async {
    try {
      _emitState(SignUpLoadingState());
      final inviteDoc = await _firestore.collection('family_invites').doc(email).get();

      if (!inviteDoc.exists) {
        _emitState(SignUpFailureState(errmsg: 'رمز الدعوة غير صالح'));
        return;
      }

      if (firstName == null || lastName == null || phone == null) {
        _emitState(SignUpFailureState(errmsg: 'املأ جميع الحقول المطلوبة'));
        return;
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'role': 'child',
        'familyId': inviteDoc['familyId'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      await inviteDoc.reference.delete();
      _emitState(SignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      _emitState(SignUpFailureState(errmsg: e.message ?? 'فشل التسجيل'));
    }
  }


  void _handleSignUpException(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      _emitState(SignUpFailureState(errmsg: 'The password provided is too weak.'));
    } else if (e.code == 'email-already-in-use') {
      _emitState(SignUpFailureState(
          errmsg: 'The account already exists for that email.'));
    } else if (e.code == 'invalid-email') {
      _emitState(SignUpFailureState(errmsg: 'The Email is Invalid.'));
    } else {
      _emitState(SignUpFailureState(errmsg: e.code));
    }
  }

  void obscureVerifyPasswordText() {
    obscureVerifyPasswordTextValue = !obscureVerifyPasswordTextValue;
    _emitState(AuthInitial());
  }

  Future<String?> getUserEmail(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      return userDoc['email'];
    }
    return null;
  }

  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        // 🔹 Prevent spam by checking last send time
        DateTime? lastEmailSent = user.metadata.lastSignInTime;
        if (lastEmailSent != null &&
            DateTime.now().difference(lastEmailSent).inMinutes < 5) {
          ShowToast(
              "Please wait before requesting another verification email.");
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
      _emitState(SignInFailureState(errMsg: "املأ جميع الحقول المطلوبة"));
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

    // 🔹 Fetch user role and familyId from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      _emitState(SignInFailureState(errMsg: "User data not found."));
      return;
    }

    role = userDoc['role'] ?? 'user';
    familyId = userDoc['familyId'];
    emailAddress = user.email;

    // 🔹 Emit SignInSuccessState with role and familyId
    _emitState(SignInSuccessState(role: role!, familyId: familyId!));
  } on FirebaseAuthException catch (e) {
    _emitState(SignInFailureState(
        errMsg: e.message ?? "Check your email and password."));
  } catch (e) {
    _emitState(SignInFailureState(errMsg: e.toString()));
  }
}

  Future<void> requestDeviceAccess(String deviceId) async {
    if (role != 'child') return;

    final otp = (1000 + Random().nextInt(9000)).toString();
    await _firestore.collection('requests').add({
      'childId': _auth.currentUser!.uid,
      'deviceId': deviceId,
      'otp': otp,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'familyId': familyId,
    });

    _emitState(OTPGeneratedState(otp: otp));
  }

  Future<void> approveRequest(String otp) async {
    try {
      final requestSnapshot = await _firestore
          .collection('requests')
          .where('otp', isEqualTo: otp)
          .where('familyId', isEqualTo: familyId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (requestSnapshot.docs.isEmpty) {
        _emitState(RequestApprovalFailureState(errMsg: 'كود التحقق غير صحيح'));
        return;
      }

      await requestSnapshot.docs.first.reference.update({
        'status': 'approved',
        'approvedBy': _auth.currentUser!.uid,
        'approvedAt': FieldValue.serverTimestamp(),
      });

      _emitState(RequestApprovalSuccessState());
    } catch (e) {
      _emitState(RequestApprovalFailureState(errMsg: e.toString()));
    }
  }

  Future<void> addUserProfile(String uid) async {
    await _firestore.collection("users").doc(uid).set({
      "first_name": firstName,
      "last_name": lastName,
      "email": emailAddress,
      "phone": phone,
      "role": "user",
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress ?? '');
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
    if (obscurePasswordTextValue == true) {
      obscurePasswordTextValue = false;
    } else {
      obscurePasswordTextValue = true;
    }
    _emitState(ObscurePasswordTextUpdateState());
  }

  Future<void> addFamilyMember({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String password,
  }) async {
    try {
      if (this.role != 'father') {
        _emitState(OperationFailureState(errMsg: 'غير مصرح بهذا الإجراء'));
        return;
      }

      // Create user account in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Log user creation
      print('User account created for $email');

      // Ensure familyId is set
      if (familyId == null) {
        familyId = await _firestore.collection('families').add({
          'fatherId': _auth.currentUser!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        }).then((doc) => doc.id);
      }

      // Record the user in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': role,
        'familyId': familyId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Log Firestore record creation
      print('User record created in Firestore for $email');

      _emitState(InviteSentSuccessState());
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      _emitState(OperationFailureState(errMsg: e.message ?? 'Failed to create user account'));
    } catch (e) {
      print('Exception: $e');
      _emitState(OperationFailureState(errMsg: e.toString()));
    }
  }

  Future<void> removeFamilyMember(String userId) async {
    try {
      if (this.role != 'father') {
        _emitState(OperationFailureState(errMsg: 'غير مصرح بهذا الإجراء'));
        return;
      }

      // Remove user from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Remove user from Firebase Authentication
      User? user = await _auth.currentUser;
      await user?.delete();

      _emitState(OperationSuccessState());
    } catch (e) {
      _emitState(OperationFailureState(errMsg: e.toString()));
    }
  }

  Future<void> updateFamilyMember({
    required String userId,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      if (this.role != 'father') {
        _emitState(OperationFailureState(errMsg: 'غير مصرح بهذا الإجراء'));
        return;
      }

      // Update user in Firestore
      await _firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      });

      _emitState(OperationSuccessState());
    } catch (e) {
      _emitState(OperationFailureState(errMsg: e.toString()));
    }
  }
}

class OTPSentState extends AuthState {
  final String role;
  OTPSentState({required this.role});
}