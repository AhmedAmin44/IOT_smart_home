import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'family_state.dart';

class FamilyCubit extends Cubit<FamilyState> {
  FamilyCubit() : super(FamilyInitial());

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'child';

  void changeRole(String? newRole) {
    if (newRole != null) {
      selectedRole = newRole;
      emit(FamilyRoleChanged(selectedRole));
    }
  }

  void sendInvite(String familyId) async {
    print("Sending invite for ${emailController.text}");

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'role': selectedRole,
        'familyId': familyId,
      });

      emit(FamilyMemberAdded());
      Fluttertoast.showToast(msg: "Add successfully!");

      emailController.clear();
      firstNameController.clear();
      lastNameController.clear();
      passwordController.clear();
    } catch (e) {
      print("Error sending invite: $e");
      Fluttertoast.showToast(msg: "Failed to send invite: $e");
    }
  }

  void removeMember(BuildContext context, String userId, String currentUserRole) async {
    if (currentUserRole != 'father') {
      Fluttertoast.showToast(msg: "Only the father can remove members.");
      return;
    }

    bool confirm = await 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secColor,
        title: const Text('Confirm Deletion',
        style:TextStyle(
          color: Colors.green,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ) ),
        content: const Text('Are you sure you want to remove this member?',
        style:TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel',style:TextStyle(
          color: Colors.green,
          fontSize: 15,
          fontWeight: FontWeight.w300
        )),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm',style:TextStyle(
          color: Colors.red,
          fontSize: 15,
          fontWeight: FontWeight.bold
        )),
          ),
        ],
      ),
    );

    if (!confirm) return;

    print("Removing member with id $userId");

    try {
      // Remove user from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Remove user from other relevant collections
      await FirebaseFirestore.instance.collection('family_members').doc(userId).delete();
      await FirebaseFirestore.instance.collection('roles').doc(userId).delete();

      // Remove user from Firebase Authentication
      User? user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }

      emit(FamilyMemberRemoved(userId));
      Fluttertoast.showToast(msg: "Member removed successfully!");
    } catch (e) {
      print("Error removing member: $e");
      Fluttertoast.showToast(msg: "Failed to remove member: $e");
    }
  }

  void updateMember(BuildContext context, String userId, String firstName, String lastName, String role) {
    print("Updating member $userId with new values");
    emit(FamilyMemberUpdated(userId, firstName, lastName, role));
  }
}
