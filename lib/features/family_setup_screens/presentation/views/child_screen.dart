import 'package:IOT_SmartHome/features/family_setup_screens/presentation/widgets/family_id_card.dart';
import 'package:flutter/material.dart';

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