import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:screenutil_module/main.dart';

class HomeView extends StatelessWidget {
  final String role;
  final String familyId;

  const HomeView({super.key, required this.role, required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 8,
            ),
          ),
          if (role == 'father' || role == 'mother')
            SliverToBoxAdapter(
              child: Column(
                spacing: 25,
                children: [
                  HomeContainer(
                    familyId: familyId,
                    role: 'father',
                  )
                ],
              ),
            ),
          if (role == 'child')
            SliverToBoxAdapter(
              child: HomeContainer(
                familyId: familyId,
                role: "child",
              ),
            ),
        ],
      ),
    );
  }
}

/// 🔹 Father , mother ,and child home



Widget buildConsumptionChart() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildBar('MO', 45),
      buildBar('TU', 30),
      buildBar('WE', 30),
      buildBar('TH', 30),
      buildBar('FR', 90, isHighlighted: true),
      buildBar('SA', 30),
      buildBar('SU', 30),
    ],
  );
}

Widget buildBar(String day, double value, {bool isHighlighted = false}) {
  return Column(
    children: [
      Container(
        height: value * 3,
        width: 40,
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            value.toInt().toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(day, style: const TextStyle(color: Colors.white)),
    ],
  );
}

Future<String> getUserName() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'User';

  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (!userDoc.exists) return 'User';

  return userDoc.data()?['firstname'] ?? 'User';
}

