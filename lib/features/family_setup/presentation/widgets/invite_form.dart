import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/auth/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

class InviteForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passwordController;
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onSendInvite;

  InviteForm({
    Key? key,
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
    required this.passwordController,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSendInvite,
  }) : super(key: key);
  GlobalKey<FormState> sendInviteFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: sendInviteFormKey,
      child: Column(
        children: [
          TextFField(
            labelText: 'First Name',
            onChanged: (value) => firstNameController.text = value,
          ),
          TextFField(
            labelText: 'Last Name',
            onChanged: (value) => lastNameController.text = value,
          ),
          TextFField(
            labelText: 'Email',
            onChanged: (value) => emailController.text = value,
            suffixIcon: const Icon(Icons.email, color: Colors.white),
          ),
          TextFField(
            labelText: 'Password',
            onChanged: (value) => passwordController.text = value,
            obscureText: true,
            suffixIcon: const Icon(Icons.lock, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 8, left: 8),
            child: DropdownButtonFormField<String>(
              value: selectedRole ?? 'Role!',
              dropdownColor: AppColors.secColor,
              style: TextStyle(color: Colors.green),
              decoration: InputDecoration(
                labelText: 'Select Role',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Choose a role',
                hintStyle: TextStyle(color: Colors.white54),
                border: getBordrStyle(),
                enabledBorder: getBordrStyle(),
                focusedBorder: getBordrStyle(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'child',
                  child: Text('Child', style: TextStyle(color: Colors.green)),
                ),
                DropdownMenuItem(
                  value: 'mother',
                  child: Text('Mother', style: TextStyle(color: Colors.green)),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onRoleChanged(newValue);
                }
              },
            ),
          ),
          const SizedBox(height: 25),
          CustomBotton(text: 'Send Invite', onPressed: onSendInvite),
        ],
      ),
    );
  }
}
