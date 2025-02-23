import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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