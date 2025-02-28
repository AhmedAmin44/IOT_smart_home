import 'package:IOT_SmartHome/features/parent/presentation/parent_cubit/parent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_images.dart';

import '../../../../device/presentation/views/device_list_screen.dart';
import '../../../../family_setup/presentation/views/family_setup_screen.dart';
import '../../../../parent/presentation/view/device_control_screen.dart';
import '../../../../parent/presentation/view/request_approval_screen.dart';
import '../../../../parent/presentation/view/parental_dashboard.dart';
import '../home_view.dart';

// Import screens from your features folders:
class HomeNavBarWidget extends StatelessWidget {
  final String role;
  final String familyId;
  final PersistentTabController _controller = PersistentTabController();
  PersistentTabController get controller => _controller;

  HomeNavBarWidget({Key? key, required this.role, required this.familyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarItems(),
      controller: _controller,
      navBarStyle: NavBarStyle.style7,
      backgroundColor: AppColors.prColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7), topRight: Radius.circular(5)),
      ),
      onItemSelected: (index) async {
        _controller.jumpToTab(index);
      },
    );
  }

  List<Widget> _buildScreens() {
    if (role == 'father') {
      return [
        HomeView(role: role, familyId: familyId),
        FamilySetupScreen(role: role, familyId: familyId),
        // const DeviceControlScreen(),
        BlocProvider(
          create: (context) => ParentCubit()..initialize(familyId: familyId),
          child: DeviceControlScreen(role: role, familyId: familyId),
        ),
        ParentalDashboard(familyId: familyId),
      ];
    } else if (role == 'mother') {
      return [
        HomeView(role: role, familyId: familyId),
        BlocProvider(
          create: (context) => ParentCubit()..initialize(familyId: familyId),
          child: DeviceControlScreen(role: role, familyId: familyId),
        ),
        ParentalDashboard(familyId: familyId),
      ];
    } else if (role == 'child') {
      return [
        HomeView(role: role, familyId: familyId),
        DeviceListScreen(role: role, familyId: familyId),
      ];
    } else {
      return [HomeView(role: role, familyId: familyId)];
    }
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    if (role == 'father') {
      return [
        PersistentBottomNavBarItem(
          icon: Image.asset(AppImages.home),
          title: "Home",
          activeColorSecondary: Colors.white,
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          inactiveIcon: Image.asset(AppImages.home_inactive),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.family_restroom),
          title: "Family Setup",
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          activeColorSecondary: Colors.white,
          inactiveIcon: const Icon(Icons.family_restroom_outlined),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.devices),
          title: "Device Control",
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          activeColorSecondary: Colors.white,
          inactiveIcon: const Icon(Icons.devices_outlined),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.dashboard),
          title: "Dashboard",
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          activeColorSecondary: Colors.white,
          inactiveIcon: const Icon(Icons.dashboard_outlined),
        ),
      ];
    } else if (role == 'mother') {
      return [
        PersistentBottomNavBarItem(
          icon: Image.asset(AppImages.home),
          title: "Home",
          activeColorSecondary: Colors.white,
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          inactiveIcon: Image.asset(AppImages.home_inactive),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.devices),
          title: "Device Control",
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          activeColorSecondary: Colors.white,
          inactiveIcon: const Icon(Icons.devices_outlined),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.dashboard),
          title: "Dashboard",
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          activeColorSecondary: Colors.white,
          inactiveIcon: const Icon(Icons.dashboard_outlined),
        ),
      ];
    } else if (role == 'child') {
      return [
        PersistentBottomNavBarItem(
          icon: Image.asset(AppImages.home),
          title: "Home",
          activeColorSecondary: Colors.white,
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          inactiveIcon: Image.asset(AppImages.home_inactive),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.devices),
          title: "Devices",
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          activeColorSecondary: Colors.white,
          inactiveIcon: const Icon(Icons.devices_outlined),
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: Image.asset(AppImages.home),
          title: "Home",
          activeColorSecondary: Colors.white,
          activeColorPrimary: const Color.fromARGB(179, 93, 148, 86),
          inactiveIcon: Image.asset(AppImages.home_inactive),
        ),
      ];
    }
  }
}
