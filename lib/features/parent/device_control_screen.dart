import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({Key? key}) : super(key: key);
  @override
  _DeviceControlScreenState createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  List<Map<String, dynamic>> devices = [
    {'name': 'Living Room Light', 'status': true, 'lastUsed': '10:00 AM'},
    {'name': 'AC', 'status': false, 'lastUsed': '09:30 AM'},
  ];
  final TextEditingController newDeviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        
        title: const Icon(
          FontAwesomeIcons.lightbulb,
          color: Colors.green,
          size: 28,
        ),
        centerTitle: true,
        
      ),  
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomBotton(
  text: "Add New Device !",
  onPressed: () {
    showAddDeviceDialog(context);
  },
),

           
           
            const SizedBox(height: 20),
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
                          IconButton(
                            icon: const Icon(Icons.delete,size: 25,color: Colors.red,),
                            onPressed: () {
                              setState(() {
                                devices.removeAt(index);
                              });
                              ShowToast("Device deleted: ${device['name']}");
                              print("Device deleted: ${device['name']}");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
