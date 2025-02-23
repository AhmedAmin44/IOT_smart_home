import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

