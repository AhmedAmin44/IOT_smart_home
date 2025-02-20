import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/setting_cubit/setting_cubit.dart';

class UserSavePasswordButton extends StatelessWidget {
  const UserSavePasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomBotton(
        color: const Color.fromARGB(255, 75, 112, 108),
        text: 'This is OK?',
        onPressed: () async {
          final password = context
              .read<PasswordGenerateCubit>()
              .state
              .passwordController
              .text;
          final user = FirebaseAuth.instance.currentUser;

          String userName = "Default Name";

          if (user != null) {
            try {
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

              if (userDoc.exists) {
                userName =
                    '${userDoc.data()?['first_name'] ?? 'Default'} ${userDoc.data()?['last_name'] ?? 'Name'}';
              }
            } catch (e) {
              print('Error fetching user name from Firestore: $e');
            }
          }

          final timestamp = DateTime.now();

          await FirebaseFirestore.instance
              .collection('userPasswords')
              .doc(user?.uid)
              .set({
            'userName': userName,
            'password': password,
            'timestamp': timestamp,
          });

          // Save the timestamp to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .update({
            'lastPasswordGenerationTime': timestamp.millisecondsSinceEpoch
          });
          ShowToast("Please close app and open it again to see the changes");

          // Navigate to home
          if (!context.mounted) return;
          context
              .go('/homeNavBar'); // Navigate to screen 0 inside the homeNavBar
        },
      ),
    );
  }
}
