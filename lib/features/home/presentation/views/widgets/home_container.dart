import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/home_view.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:screenutil_module/main.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key, required this.role, required this.familyId});
  final String role;
  final String familyId;
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

          FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); 
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
              // ignore: deprecated_member_use
              buildCard('Add New Device', FontAwesomeIcons.plusCircle, () {
                if (role == 'father' || role == 'mother') {
                  showAddDeviceDialog(context,familyId);
                } else {
                  ShowToast(
                      "You Can not add any device ,Only Your Parents can");
                }
              }),
              buildCard('Manage Devices', FontAwesomeIcons.server, () {
                HomeNavBarWidget? homeNavBar =
                    context.findAncestorWidgetOfExactType<HomeNavBarWidget>();
                if (homeNavBar != null) {
                  if (role == 'father' || role == 'mother') {
                    homeNavBar.controller.jumpToTab(2);
                  } else {
                    homeNavBar.controller.jumpToTab(1);
                  }
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
          buildConsumptionChart(),
        ],
      ),
    );
  }
}



Widget buildCard(
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
void showAddDeviceDialog(BuildContext context, String familyId) {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? isDanger;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey.shade900,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
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
                      setState(() {
                        isDanger = value;
                      });
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () async {
                          String type = typeController.text.trim();
                          String name = nameController.text.trim();

                          if (type.isEmpty || name.isEmpty || isDanger == null) {
                            Fluttertoast.showToast(
                                msg: "All fields are required!",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red);
                            return;
                          }
                          await addDevice(
                            familyId,
                            type,
                            name,
                            isDanger == "Yes",
                          );

                          Fluttertoast.showToast(
                              msg: "Device added successfully!",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green);

                          Navigator.pop(context);
                        },
                        child: const Text("Save",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

Future<void> addDevice(  String familyId, String type, String name, bool isDangerous) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('devices').add({
      'type': type, 
      'name': name,
      'status': false,
      'isDangerous': isDangerous,
      'familyId': familyId,
      'lastUsed': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error adding device: ${e.toString()}");
  }
}
