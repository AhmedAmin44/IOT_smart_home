import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/core/utils/app_string.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:IOT_SmartHome/features/auth/widgets/welcome_text.dart';
import 'package:IOT_SmartHome/features/home/presentation/home_cubit/home_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, IconButton? trailing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow(),
          FutureBuilder<String>(
            future: _getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Error loading user name');
              }
              return welcomeHeader(snapshot.data ?? 'User');
            },
          ),
        ],
      ),
    );
  }

  
  Widget welcomeHeader(String userName) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
        const WelcomeWidget(
          text: "Hello",
        ),
        Text(" $userName",
            style: const TextStyle(
              fontSize: 30,
              color: const Color.fromARGB(179, 93, 148, 86),
            )),
      ],
    );
  }

  Padding headerRow() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.list,
              color: AppColors.offWhite,
              size: 25,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppColors.offWhite,
              size: 25,
            ),
            onPressed: () {},
          ),
          // log_out()
        ],
      ),
    );
  }
}

Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'User';

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return 'User';

    return userDoc.data()?['firstName'] ?? 'User';
  }
