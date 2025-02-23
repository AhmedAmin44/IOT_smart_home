import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/family_id_card.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/family_members_list.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/invite_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FatherView extends StatefulWidget {
  final String familyId;

  const FatherView({Key? key, required this.familyId}) : super(key: key);

  @override
  State<FatherView> createState() => FatherViewState();
}

class FatherViewState extends State<FatherView> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'child';

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FamilyIdCard(familyId: widget.familyId),
            const SizedBox(height: 20),
            InviteForm(
              emailController: emailController,
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              passwordController: passwordController,
              selectedRole: selectedRole,
              onRoleChanged: (value) => setState(() => selectedRole = value!),
              onSendInvite: () => sendInvite(context),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FamilyMembersList(
                familyId: widget.familyId,
                onRemoveMember: removeMember,
                onUpdateMember: updateMember,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendInvite(BuildContext context) {
    print("Step: Sending invite for ${emailController.text}");
    context.read<AuthCubit>().addFamilyMember(
          email: emailController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          role: selectedRole,
          password: passwordController.text,
        );
    print("Step: Invite function called.");
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    passwordController.clear();
  }

  void removeMember(BuildContext context, String userId) {
    print("Step: Removing member with id $userId");
    context.read<AuthCubit>().removeFamilyMember(userId);
  }

  void updateMember(BuildContext context, String userId, String firstName,
      String lastName, String role) {
    print("Step: Updating member $userId with new values");
    context.read<AuthCubit>().updateFamilyMember(
          userId: userId,
          firstName: firstName,
          lastName: lastName,
          role: role,
        );
  }
}
