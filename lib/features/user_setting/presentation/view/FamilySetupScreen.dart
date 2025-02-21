import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/presentation/auth_cubit/auth_cubit.dart';
import '../../../auth/presentation/auth_cubit/auth_state.dart';

class FamilySetupScreen extends StatelessWidget {
  final String role;
  final String familyId;

  const FamilySetupScreen({super.key, required this.role, required this.familyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة العائلة'),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // Handle states here
          },
          builder: (context, state) {
            return RoleBasedView(
              role: role,
              familyId: familyId,
            );
          },
        ),
      ),
    );
  }
}

class RoleBasedView extends StatelessWidget {
  final String role;
  final String familyId;

  const RoleBasedView({
    required this.role,
    required this.familyId,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'father':
        return FatherView(familyId: familyId);
      case 'mother':
        return MotherView(familyId: familyId);
      case 'child':
        return ChildView(familyId: familyId);
      default:
        return const Center(child: Text('صلاحيات غير معروفة'));
    }
  }
}

// ---------------------- واجهة الأب ----------------------
class FatherView extends StatefulWidget {
  final String familyId;

  const FatherView({required this.familyId});

  @override
  State<FatherView> createState() => FatherViewState();
}

class FatherViewState extends State<FatherView> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController(); // Add password controller
  String selectedRole = 'child';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FamilyIdCard(familyId: widget.familyId),
          const SizedBox(height: 20),
          InviteForm(
            emailController: emailController,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            passwordController: passwordController, // Pass password controller
            selectedRole: selectedRole,
            onRoleChanged: (value) => setState(() => selectedRole = value!),
            onSendInvite: () => sendInvite(context),
          ),
          const SizedBox(height: 20),
          Expanded(child: FamilyMembersList(
            onRemoveMember: removeMember,
            onUpdateMember: updateMember,
          )),
        ],
      ),
    );
  }

  void sendInvite(BuildContext context) {
    context.read<AuthCubit>().addFamilyMember(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      role: selectedRole,
      password: passwordController.text, // Pass the password
    );
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    passwordController.clear(); // Clear the password field
  }

  void removeMember(BuildContext context, String userId) {
    context.read<AuthCubit>().removeFamilyMember(userId);
  }

  void updateMember(BuildContext context, String userId, String firstName, String lastName, String role) {
    context.read<AuthCubit>().updateFamilyMember(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );
  }
}

// ---------------------- واجهة الأم ----------------------
class MotherView extends StatelessWidget {
  final String familyId;

  const MotherView({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FamilyIdCard(familyId: familyId),
          const SizedBox(height: 20),
          Expanded(child: FamilyMembersList(
            onRemoveMember: (context, userId) {},
            onUpdateMember: (context, userId, firstName, lastName, role) {},
          )),
        ],
      ),
    );
  }
}

// ---------------------- واجهة الابن ----------------------
class ChildView extends StatelessWidget {
  final String familyId;

  const ChildView({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FamilyIdCard(familyId: familyId),
          const SizedBox(height: 20),
          const Text('اتصل بالأب لإجراء أي تعديلات'),
        ],
      ),
    );
  }
}

// ---------------------- مكونات مشتركة ----------------------
class FamilyIdCard extends StatelessWidget {
  final String familyId;

  const FamilyIdCard({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.family_restroom, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('رمز العائلة'),
                  SelectableText(
                    familyId,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => copyToClipboard(context),
            ),
          ],
        ),
      ),
    );
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: familyId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الرمز')),
    );
  }
}

class InviteForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passwordController; // Add password controller
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onSendInvite;

  const InviteForm({
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
    required this.passwordController, // Add password controller
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSendInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(
            labelText: 'الاسم الأول',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(
            labelText: 'اسم العائلة',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        TextField(
          controller: passwordController, // Add password field
          decoration: const InputDecoration(
            labelText: 'كلمة المرور',
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        DropdownButtonFormField<String>(
          value: selectedRole,
          items: const [
            DropdownMenuItem(value: 'child', child: Text('ابن/ابنة')),
            DropdownMenuItem(value: 'mother', child: Text('أم')),
          ],
          onChanged: onRoleChanged,
        ),
        ElevatedButton(
          onPressed: onSendInvite,
          child: const Text('إرسال دعوة'), // This button triggers the addition of a family member
        ),
      ],
    );
  }
}

class FamilyMembersList extends StatelessWidget {
  final Function(BuildContext, String) onRemoveMember;
  final Function(BuildContext, String, String, String, String) onUpdateMember;

  const FamilyMembersList({
    required this.onRemoveMember,
    required this.onUpdateMember,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('familyId', isEqualTo: context.read<AuthCubit>().familyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final member = snapshot.data!.docs[index];
            return ListTile(
              title: Text(member['email']),
              subtitle: Text(member['role']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Show dialog to update member
                      showDialog(
                        context: context,
                        builder: (context) {
                          final firstNameController = TextEditingController(text: member['firstName']);
                          final lastNameController = TextEditingController(text: member['lastName']);
                          String selectedRole = member['role'];
                          return AlertDialog(
                            title: const Text('تعديل عضو العائلة'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'الاسم الأول',
                                  ),
                                ),
                                TextField(
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'اسم العائلة',
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: selectedRole.isNotEmpty ? selectedRole : 'child',
                                  items: const [
                                    DropdownMenuItem(value: 'child', child: Text('ابن/ابنة')),
                                    DropdownMenuItem(value: 'mother', child: Text('أم')),
                                    DropdownMenuItem(value: 'father', child: Text('أب')), // Ensure 'father' is included
                                  ],
                                  onChanged: (value) => selectedRole = value!,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onUpdateMember(
                                    context,
                                    member.id,
                                    firstNameController.text,
                                    lastNameController.text,
                                    selectedRole,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text('تعديل'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemoveMember(context, member.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
