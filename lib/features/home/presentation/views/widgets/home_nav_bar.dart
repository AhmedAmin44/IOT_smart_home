import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_images.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/home_view.dart';
import 'package:IOT_SmartHome/features/user_setting/presentation/view/user_setting.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNavBarWidget extends StatelessWidget {
  final String role;
  final PersistentTabController _controller = PersistentTabController();

  PersistentTabController get controller => _controller;

  HomeNavBarWidget({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarItems(),
      controller: _controller,
      navBarStyle: NavBarStyle.style7,
      backgroundColor: const Color.fromARGB(255, 73, 89, 97),
      decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7), topRight: Radius.circular(5))),
      onItemSelected: (index) async {
        if (index == 1 && role != 'admin') {
          final prefs = await SharedPreferences.getInstance();
          final lastPasswordGenerationTime =
              prefs.getInt('lastPasswordGenerationTime') ?? 0;
          final currentTime = DateTime.now().millisecondsSinceEpoch;
          final timeDifference = currentTime - lastPasswordGenerationTime;

          if (timeDifference < 20 * 60 * 1000) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'You can generate a new password after 20 minutes.')),
            );
            return;
          }
        }
        _controller.jumpToTab(index);
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeView(role: role),
      SettingGeneratePassword(isAdmin: role == 'admin'),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset(AppImages.home),
        title: ("Home"),
        activeColorSecondary: AppColors.lightGrey,
        activeColorPrimary: const Color.fromARGB(31, 223, 219, 219),
        inactiveIcon: Image.asset(AppImages.home_inactive),
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(AppImages.setting),
        title: ("Setting"),
        activeColorPrimary: const Color.fromARGB(31, 255, 255, 255),
        activeColorSecondary: AppColors.lightGrey,
        inactiveIcon: Image.asset(AppImages.setting_inactive),
      ),
    ];
  }
}
