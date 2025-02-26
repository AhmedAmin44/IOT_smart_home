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

        final members = snapshot.data!.docs;

        if (members.isEmpty) {
          return const Center(child: Text('No family members found.'));
        }

        return Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];

              return MemberCard(
                member: member,
                onRemoveMember: onRemoveMember,
                onUpdateMember: onUpdateMember,
              );
            },
          ),
        );
      },
    );
  }
}

class MemberCard extends StatelessWidget {
  final QueryDocumentSnapshot member;
  final Function(BuildContext, String) onRemoveMember;
  final Function(BuildContext, String, String, String, String) onUpdateMember;

  const MemberCard({
    Key? key,
    required this.member,
    required this.onRemoveMember,
    required this.onUpdateMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            // IconButton(
            //   icon: const Icon(Icons.edit, color: Colors.blue),
            //   onPressed: () => _showUpdateDialog(context, member),
            // ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemoveMember(context, member.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, QueryDocumentSnapshot member) {
    final firstNameController =
        TextEditingController(text: member['firstName']);
    final lastNameController = TextEditingController(text: member['lastName']);
    String selectedRole = member['role'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Family Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(firstNameController, 'First Name'),
              _buildTextField(lastNameController, 'Last Name'),
              _buildRoleDropdown(selectedRole, (value) {
                selectedRole = value!;
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildRoleDropdown(
      String selectedRole, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedRole.isNotEmpty ? selectedRole : 'child',
      items: const [
        DropdownMenuItem(value: 'child', child: Text('Child')),
        DropdownMenuItem(value: 'mother', child: Text('Mother')),
        DropdownMenuItem(value: 'father', child: Text('Father')),
      ],
      onChanged: onChanged,
    );
  }
}
