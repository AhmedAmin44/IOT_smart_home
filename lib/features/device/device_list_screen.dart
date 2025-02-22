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
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          var device = devices[index];
          return ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: Text(device['name']),
            subtitle: Text(device['status'] ? 'On' : 'Off'),
            trailing: isRequesting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isRequesting = true;
                      });
                      print("Requesting access for ${device['name']}");
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          isRequesting = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OTPDisplayScreen(otpCode: "4D6F"),
                          ),
                        );
                      });
                    },
                    child: const Text('Request Access'),
                  ),
          );
        },
      ),
    );
  }
}
