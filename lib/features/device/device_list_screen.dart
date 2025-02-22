import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'otp_display_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({Key? key}) : super(key: key);
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<Map<String, dynamic>> devices = [
    {'name': 'Living Room Light', 'status': false},
    {'name': 'AC', 'status': true},
  ];
  bool isRequesting = false;

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
      body: 
        Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  var device = devices[index];
                  return Card(
                    color: AppColors.secColor,
                    child: ListTile(
                      title: Text(device['name'],
                      
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                    ),),
                      subtitle: Text(
                        'Status: ${device['status'] ? 'On' : 'Off'}\n - Last used: ${device['lastUsed']}',
                        style: TextStyle(color: Colors.white),
                        ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: device['status'],
                             activeColor: Colors.green,
  inactiveTrackColor: Colors.grey,
                            onChanged: (val) {
                              setState(() {
                                devices[index]['status'] = val;
                                
                              });
                              ShowToast("Device ${device['name']} status changed to $val");
                              print("Device ${device['name']} status changed to $val");
                            },
                          ),
                          
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
