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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العائلة'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle states here
        },
        builder: (context, state) {
          return _RoleBasedView(
            role: role,
            familyId: familyId,
          );
        },
      ),
    );
  }
}

class _RoleBasedView extends StatelessWidget {
  final String role;
  final String familyId;

  const _RoleBasedView({
    required this.role,
    required this.familyId,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'father':
        return _FatherView(familyId: familyId);
      case 'mother':
        return _MotherView(familyId: familyId);
      case 'child':
        return _ChildView(familyId: familyId);
      default:
        return const Center(child: Text('صلاحيات غير معروفة'));
    }
  }
}

// ---------------------- واجهة الأب ----------------------
class _FatherView extends StatefulWidget {
  final String familyId;

  const _FatherView({required this.familyId});

  @override
  State<_FatherView> createState() => _FatherViewState();
}

class _FatherViewState extends State<_FatherView> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _selectedRole = 'child';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _FamilyIdCard(familyId: widget.familyId),
          const SizedBox(height: 20),
          _InviteForm(
            emailController: _emailController,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            selectedRole: _selectedRole,
            onRoleChanged: (value) => setState(() => _selectedRole = value!),
            onSendInvite: () => _sendInvite(context),
          ),
          const SizedBox(height: 20),
          const Expanded(child: _FamilyMembersList()),
        ],
      ),
    );
  }

  void _sendInvite(BuildContext context) {
    context.read<AuthCubit>().sendFamilyInvite(
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      role: _selectedRole,
    );
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
  }
}

// ---------------------- واجهة الأم ----------------------
class _MotherView extends StatelessWidget {
  final String familyId;

  const _MotherView({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _FamilyIdCard(familyId: familyId),
          const SizedBox(height: 20),
          const Expanded(child: _FamilyMembersList()),
        ],
      ),
    );
  }
}

// ---------------------- واجهة الابن ----------------------
class _ChildView extends StatelessWidget {
  final String familyId;

  const _ChildView({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FamilyIdCard(familyId: familyId),
          const SizedBox(height: 20),
          const Text('اتصل بالأب لإجراء أي تعديلات'),
        ],
      ),
    );
  }
}

// ---------------------- مكونات مشتركة ----------------------
class _FamilyIdCard extends StatelessWidget {
  final String familyId;

  const _FamilyIdCard({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.family_restroom, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('رمز العائلة'),
                SelectableText(
                  familyId,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(context),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: familyId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الرمز')),
    );
  }
}

class _InviteForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onSendInvite;

  const _InviteForm({
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
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
          child: const Text('إرسال دعوة'),
        ),
      ],
    );
  }
}

class _FamilyMembersList extends StatelessWidget {
  const _FamilyMembersList();

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
              trailing: _getRoleBadge(member['role']),
            );
          },
        );
      },
    );
  }

  Widget _getRoleBadge(String role) {
    final color = role == 'father' ? Colors.blue : 
                role == 'mother' ? Colors.pink : Colors.green;
    return Chip(
      label: Text(role),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}