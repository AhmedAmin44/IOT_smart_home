import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:go_router/go_router.dart';
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
            ///////
            SliverToBoxAdapter(
                child:Column(spacing: 25,
                  children: [
                      HomeContainer(
              role: 'father',
            // ), Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 8.0),
            //     child: CustomBotton(
            //       text: 'Manage Family',
            //       onPressed: () => context.go('/family-setup',
            //           extra: {'role': role, 'familyId': familyId}),
            //       color: AppColors.prColor,
            //     )),
                )],
                ),),
          if (role == 'child')
            SliverToBoxAdapter(
              child: HomeContainer(
                role: "child",
              ),
            ),

          
        ],
      ),
    );
  }
}

/// 🔹 Father , mother ,and child home
class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key, required this.role});
  final String role;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome,',
            style: TextStyle(fontSize: 22.sp, color: Colors.white),
          ),

          // FutureBuilder to handle async getUserName()
          FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading indicator
              } else if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(fontSize: 25.sp, color: Colors.red),
                );
              } else {
                return Text(
                  snapshot.data ?? "Guest",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                );
              }
            },
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCard('Add New Device', FontAwesomeIcons.plusCircle, () {
                if (role == 'father' || role == 'mother') {
                  showAddDeviceDialog(context);
                } else {
                  ShowToast("You Can not add any device ,Only Your Parents can");
                }
              }),
              _buildCard('Manage Devices', FontAwesomeIcons.server, () {
                HomeNavBarWidget? homeNavBar =
                    context.findAncestorWidgetOfExactType<HomeNavBarWidget>();
                if (homeNavBar != null) {
                  if (role == 'father' || role == 'mother') {
                    homeNavBar.controller.jumpToTab(2);
                  } else {
                    homeNavBar.controller.jumpToTab(1);
                  }
                  // Assuming "Device Control" is at index 2
                }
              }),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Icon(FontAwesomeIcons.droplet, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                'My Consumption',
                style: TextStyle(
                    fontSize: 18, color: Colors.green, fontFamily: "Poppins"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildConsumptionChart(),
        ],
      ),
    );
  }
}

Widget _buildCard(
  String title,
  IconData icon,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 160,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}

Widget _buildConsumptionChart() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildBar('MO', 45),
      _buildBar('TU', 30),
      _buildBar('WE', 30),
      _buildBar('TH', 30),
      _buildBar('FR', 90, isHighlighted: true),
      _buildBar('SA', 30),
      _buildBar('SU', 30),
    ],
  );
}

Widget _buildBar(String day, double value, {bool isHighlighted = false}) {
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

  return userDoc.data()?['firstName'] ?? 'User';
}

void showAddDeviceDialog(BuildContext context) {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? isDanger;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    backgroundColor: Colors.grey.shade900,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              16, 
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Device",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: typeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter Device Type",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter Device Name",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: isDanger,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: ["Yes", "No"].map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.green)),
                  );
                }).toList(),
                onChanged: (value) {
                  isDanger = value;
                },
                decoration: InputDecoration(
                  labelText: "Is Danger?",
                  labelStyle: const TextStyle(color: Colors.red),
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.green)),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      String type = typeController.text.trim();
                      String name = nameController.text.trim();

                      if (type.isEmpty || name.isEmpty || isDanger == null) {
                        return;
                      }

                      print("Type: $type");
                      print("Name: $name");
                      print("Is Danger? $isDanger");

                      Navigator.pop(context);
                    },
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
