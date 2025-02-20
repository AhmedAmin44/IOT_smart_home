import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/features/home/presentation/home_cubit/home_cubit.dart';

// ignore: camel_case_types
class log_out extends StatelessWidget {
  const log_out({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              showLogoutDialog(context);
            },
            icon: Icon(
              Icons.login_outlined,
              size: 30,
              color: Colors.red,
            )),
        Text(
          "Logout",
          style: TextStyle(color: Colors.red, fontSize: 11),
        )
      ],
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(" Are you sure ? "),
        content: Text("Are you sure you want to log out of our app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              HomeCubit().logout();
            },
            child: Text(
              "LogOut ",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}
