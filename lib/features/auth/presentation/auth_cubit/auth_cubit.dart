import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  late String firstName;
  late String lastName;
  late String emailAddress;
  late String password;
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  GlobalKey<FormState> signInFormKey = GlobalKey();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey();
  bool? termsAndConditionsChekBox = false;
  bool? obscurePasswordTextValue = true;

  Future<void> signUpWithEmailAndPassword() async {
    try {
      emit(SignUpLoadingState());
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress!,
        password: password!,
      );
      await addUserProfile();
      await VerifyEmail();
      emit(SignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      SignUpHandleException(e);
    } catch (e) {
      emit(SignUpFailureState(errmsg: e.toString()));
    }
  }


  void SignUpHandleException(FirebaseAuthException e) {
     if (e.code == 'weak-password') {
      emit(SignUpFailureState(errmsg: 'The password provided is too weak.'));
    } else if (e.code == 'email-already-in-use') {
      emit(SignUpFailureState(
          errmsg: 'The account already exists for that email.'));
    }else if (e.code == 'invalid-email') {
      emit(SignUpFailureState(
          errmsg: 'The Email is Invalid.'));
    }else{
      emit(SignUpFailureState(
          errmsg:e.code));
    }
  }


  Future <void> VerifyEmail()async{
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
}

void UpdateTermsAndConditionsChekBox({newValue}) {
    termsAndConditionsChekBox = newValue;
    emit(TermsAndConditionsChekBoxState());
  }


  void obscurePasswordText() {
    if (obscurePasswordTextValue == true) {
      obscurePasswordTextValue = false;
    } else {
      obscurePasswordTextValue = true;
    }
    emit(ObscurePasswordTextUpdateState());
  }




  //SignIn
  Future<void> signInWithEmailAndPassword() async {
    try {
      emit(SignInLoadingState());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress!,
        password: password!,
      );
      emit(SignInSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInFailureState(errMsg: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(SignInFailureState(
            errMsg: 'Wrong password provided for that user.'));
      } else{
        emit(SignInFailureState(
          errMsg: 'Chek your Email and Password'));
      }
    }
     catch (e) {
      emit(
          SignInFailureState(errMsg: e.toString()));
    }
  }


  Future<void> resetPasswordWithLink() async{
    try {emit(ResetPasswordLoadingState());
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress!);
      emit(ResetPasswordSuccessState());
    } catch (e) {
      emit(ResetPasswordFailureState(errMsg: e.toString()));
    }
  }




  Future<void> addUserProfile()async{
     CollectionReference users = FirebaseFirestore.instance.collection("users");
    await users.add(
      {
        "first_name":firstName,
        "last_name":lastName,
        "email":emailAddress,
        "password":password,
      }
    );
  }
}
