import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

import '../../auth/presentation/auth_cubit/auth_cubit.dart';
import '../../auth/presentation/auth_cubit/auth_state.dart';

class FamilySetupScreen extends StatelessWidget {
  final String role;
  final String familyId;

  const FamilySetupScreen({Key? key, required this.role, required this.familyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit()..initialize(familyId: familyId, role: role),
      child: Scaffold(
        appBar:AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Icon(
          FontAwesomeIcons.lightbulb,
          color: Colors.green,
          size: 28,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
        
        
        
        
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // Print state changes for debugging
            print("AuthState changed: $state");
          },
          builder: (context, state) {
            return RoleBasedView(role: role, familyId: familyId);
          },
        ),
      ),
    );
  }
}

class RoleBasedView extends StatelessWidget {
  final String role;
  final String familyId;

  const RoleBasedView({Key? key, required this.role, required this.familyId})
      : super(key: key);

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
        return const Center(child: Text('Unknown permissions'));
    }
  }
}

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

class MotherView extends StatelessWidget {
  final String familyId;

  const MotherView({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FamilyIdCard(familyId: familyId),
          const SizedBox(height: 20),
          Expanded(
            child: FamilyMembersList(
              familyId: familyId,
              onRemoveMember: (context, userId) {},
              onUpdateMember: (context, userId, firstName, lastName, role) {},
            ),
          ),
        ],
      ),
    );
  }
}

class ChildView extends StatelessWidget {
  final String familyId;

  const ChildView({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FamilyIdCard(familyId: familyId),
          const SizedBox(height: 20),
          const Text('Contact your father for any changes'),
        ],
      ),
    );
  }
}

class FamilyIdCard extends StatelessWidget {
  final String familyId;

  const FamilyIdCard({Key? key, required this.familyId}) : super(key: key);

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
                  const Text('Family ID'),
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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Family ID copied')));
  }
}

class InviteForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passwordController;
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onSendInvite;

  const InviteForm({
    Key? key,
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
    required this.passwordController,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSendInvite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        DropdownButtonFormField<String>(
          value: selectedRole,
          items: const [
            DropdownMenuItem(value: 'child', child: Text('Child')),
            DropdownMenuItem(value: 'mother', child: Text('Mother')),
          ],
          onChanged: onRoleChanged,
        ),
        ElevatedButton(
          onPressed: onSendInvite,
          child: const Text('Send Invite'),
        ),
      ],
    );
  }
}

class FamilyMembersList extends StatelessWidget {
  final String familyId;
  final Function(BuildContext, String) onRemoveMember;
  final Function(BuildContext, String, String, String, String) onUpdateMember;

  const FamilyMembersList({
    Key? key,
    required this.familyId,
    required this.onRemoveMember,
    required this.onUpdateMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('familyId', isEqualTo: familyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print("Step: No family members data available yet.");
          return const CircularProgressIndicator();
        }
        print("Step: Family members data received.");
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          final firstNameController =
                              TextEditingController(text: member['firstName']);
                          final lastNameController =
                              TextEditingController(text: member['lastName']);
                          String selectedRole = member['role'];
                          return AlertDialog(
                            title: const Text('Update Family Member'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'First Name',
                                  ),
                                ),
                                TextField(
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Last Name',
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: selectedRole.isNotEmpty
                                      ? selectedRole
                                      : 'child',
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'child', child: Text('Child')),
                                    DropdownMenuItem(
                                        value: 'mother', child: Text('Mother')),
                                    DropdownMenuItem(
                                        value: 'father', child: Text('Father')),
                                  ],
                                  onChanged: (value) =>
                                      selectedRole = value!,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  print("Step: Updating member ${member.id}");
                                  onUpdateMember(
                                    context,
                                    member.id,
                                    firstNameController.text,
                                    lastNameController.text,
                                    selectedRole,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Update'),
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
