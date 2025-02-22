import 'package:flutter/material.dart';
import 'device_control_screen.dart';

class ParentalDashboard extends StatelessWidget {
  const ParentalDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int totalDevices = 5;
    int activeRequests = 2;
    List<String> recentActivity = ['Device added', 'OTP approved', 'Device toggled'];

    return Scaffold(
      appBar: AppBar(title: const Text('Parental Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Devices', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(totalDevices.toString(), style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Active Requests', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(activeRequests.toString(), style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...recentActivity.map((activity) => ListTile(title: Text(activity))).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Quick access to device controls pressed");
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DeviceControlScreen()));
              },
              child: const Text('Device Controls'),
            ),
          ],
        ),
      ),
    );
  }
}
