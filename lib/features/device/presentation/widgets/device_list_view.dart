import 'package:IOT_SmartHome/features/device/presentation/widgets/device_card.dart';
import 'package:flutter/material.dart';

class DeviceListView extends StatelessWidget {
  final List<Map<String, dynamic>> devices;

  const DeviceListView({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return DeviceCard(device: device);
      },
    );
  }
}
