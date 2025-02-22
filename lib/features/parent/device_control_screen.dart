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
        
      ),      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add New Device'),
                      content: TextField(
                        controller: newDeviceController,
                        decoration: const InputDecoration(labelText: 'Device Name'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              devices.add({
                                'name': newDeviceController.text,
                                'status': false,
                                'lastUsed': 'Never',
                              });
                            });
                            print("Device added: ${newDeviceController.text}");
                            newDeviceController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add New Device'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  var device = devices[index];
                  return Card(
                    child: ListTile(
                      title: Text(device['name']),
                      subtitle: Text('Status: ${device['status'] ? 'On' : 'Off'} - Last used: ${device['lastUsed']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: device['status'],
                            onChanged: (val) {
                              setState(() {
                                devices[index]['status'] = val;
                              });
                              print("Device ${device['name']} status changed to $val");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                devices.removeAt(index);
                              });
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
