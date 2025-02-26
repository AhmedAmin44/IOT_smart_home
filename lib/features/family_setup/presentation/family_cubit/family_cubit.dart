import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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

  void sendInvite(String familyId) {
    print("Sending invite for ${emailController.text}");
    emit(FamilyMemberAdded());

    // Clear inputs after sending
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    passwordController.clear();
  }

  void removeMember(BuildContext context, String userId) {
    print("Removing member with id $userId");
    emit(FamilyMemberRemoved(userId));
  }

  void updateMember(BuildContext context, String userId, String firstName, String lastName, String role) {
    print("Updating member $userId with new values");
    emit(FamilyMemberUpdated(userId, firstName, lastName, role));
  }
}
