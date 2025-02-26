import 'package:flutter/material.dart';
import 'device_card.dart';

class DeviceListView extends StatelessWidget {
  final List<Map<String, dynamic>> devices;

  const DeviceListView({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) => DeviceCard(device: devices[index]),
    );
  }
}
