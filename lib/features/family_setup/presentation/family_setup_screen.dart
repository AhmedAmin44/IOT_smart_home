import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_string.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/auth/widgets/text_form_field.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_nav_bar.dart';
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

  const FamilySetupScreen(
      {Key? key, required this.role, required this.familyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit()..initialize(familyId: familyId, role: role),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.backspace_outlined, color: Colors.white),
            onPressed: () {

              HomeNavBarWidget? homeNavBar =
                  context.findAncestorWidgetOfExactType<HomeNavBarWidget>();

              if (homeNavBar != null) {
                homeNavBar.controller.jumpToTab(1);
              }
            },
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
            return Expanded(child: RoleBasedView(role: role, familyId: familyId));
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
          const Text('Contact your father for any changes',
          style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
          ),
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
      color: AppColors.secColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              size: 40,
              color: AppColors.offWhite,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Family ID',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SelectableText(
                    familyId,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy,color: Colors.white,size:25 ,),
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
    value: selectedRole ?? 'child', // Ensure selectedRole is not null
    dropdownColor: AppColors.darkGrey, // Background color of the dropdown
    style: TextStyle(color: AppColors.offWhite), // Text color inside the dropdown
    decoration: InputDecoration(
      labelText: 'Select Role', // Ensure label is visible
      labelStyle: TextStyle(color: Colors.white),
      hintText: 'Choose a role', // Ensures visibility before selection
      hintStyle: TextStyle(color: Colors.white54),
      border: getBordrStyle(),
      enabledBorder: getBordrStyle(),
      focusedBorder: getBordrStyle(),
    ),
    items: [
      DropdownMenuItem(
        value: 'child',
        child: Text('Child', style: TextStyle(color: Colors.white)),
      ),
      DropdownMenuItem(
        value: 'mother',
        child: Text('Mother', style: TextStyle(color: Colors.white)),
      ),
    ],
    onChanged: (String? newValue) {
      if (newValue != null) {
        onRoleChanged(newValue); // Update state
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
          return const Center(child: CircularProgressIndicator());
        }
        
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final member = snapshot.data!.docs[index];

              return Card(
                color: AppColors.secColor,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(
                    member['email'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  subtitle: Text(
                    'Role: ${member['role']}\nID: ${member.id}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
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
                                      value: selectedRole.isNotEmpty ? selectedRole : 'child',
                                      items: const [
                                        DropdownMenuItem(value: 'child', child: Text('Child')),
                                        DropdownMenuItem(value: 'mother', child: Text('Mother')),
                                        DropdownMenuItem(value: 'father', child: Text('Father')),
                                      ],
                                      onChanged: (value) => selectedRole = value!,
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
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemoveMember(context, member.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

