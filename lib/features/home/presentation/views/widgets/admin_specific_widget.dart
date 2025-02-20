import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';

class AdminSpecificWidget extends StatelessWidget {
  const AdminSpecificWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Admin Settings",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 20),
          CustomBotton(
            color: const Color.fromARGB(255, 75, 112, 108),
            text: "Manage Users",
            onPressed: () {},
          ),
          SizedBox(height: 10),
          CustomBotton(
            color: const Color.fromARGB(255, 75, 112, 108),
            text: "System Settings",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
