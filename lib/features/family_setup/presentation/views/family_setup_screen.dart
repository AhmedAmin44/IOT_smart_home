import 'package:IOT_SmartHome/features/family_setup/presentation/views/child_screen.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/views/father_screen.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/views/mother_screen.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

import '../../../auth/presentation/auth_cubit/auth_cubit.dart';
import '../../../auth/presentation/auth_cubit/auth_state.dart';

class FamilySetupScreen extends StatelessWidget {
  final String role;
  final String familyId;

  const FamilySetupScreen(
      {Key? key, required this.role, required this.familyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit()..initialize(familyId: familyId, role: role),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.backspace_outlined, color: Colors.white),
            onPressed: () {
              HomeNavBarWidget? homeNavBar =
                  context.findAncestorWidgetOfExactType<HomeNavBarWidget>();

              if (homeNavBar != null) {
                homeNavBar.controller.jumpToTab(1);
              }
            },
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
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // Print state changes for debugging
            print("AuthState changed: $state");
          },
          builder: (context, state) {
            return Expanded(
                child: RoleBasedView(role: role, familyId: familyId));
          },
        ),
      ),
    );
  }
}

class RoleBasedView extends StatelessWidget {
  final String role;
  final String familyId;

  const RoleBasedView({Key? key, required this.role, required this.familyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'father':
        return FatherView(familyId: familyId);
      case 'mother':
        return MotherView(familyId: familyId);
      case 'child':
        return ChildView(familyId: familyId);
      default:
        return const Center(child: Text('Unknown permissions'));
    }
  }
}
