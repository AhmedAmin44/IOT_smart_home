import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:iot_smart_home_secure/core/utils/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: TextStyle(fontSize: 22.sp, color: Colors.white),
            ),
            Text(
              'Ahmed',
              style: TextStyle(
                  fontSize: 25.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(
                    'Add New Device', FontAwesomeIcons.plusCircle, () {}),
                _buildCard('Manage Devices', FontAwesomeIcons.server, () {}),
              ],
            ),
            SizedBox(height: 40.h),
            Row(
              children: [
                Icon(FontAwesomeIcons.droplet, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'My Consumption',
                  style: TextStyle(fontSize: 18, color: Colors.green,fontFamily:  "Poppins"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildConsumptionChart(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bgColor,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 35,), label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.list,size: 35), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart,size: 25), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search,size: 25), label: ''),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.start,
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
          height: value.h * 3,
          width: 40.w,
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(16.r),
          ),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              value.toInt().toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(day, style: const TextStyle(color: Colors.white)),
      ],
    );;
  }
}
