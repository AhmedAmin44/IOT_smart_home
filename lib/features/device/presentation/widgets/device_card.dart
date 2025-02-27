import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../device_cubit/device_cubit.dart';
import '../views/otp_display_screen.dart';

class DeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;

  const DeviceCard({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeviceCubit>();
    final isDangerous = device['isDangerous'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        color: Colors.grey[800],
        child: ListTile(
          title: Text(
            device['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          subtitle: Text(
            'Status: ${device['status'] ? 'On' : 'Off'}\n'
            'Last used: ${device['lastUsed'] != null ? device['lastUsed'].toString().substring(0, 16) : 'Never'}',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDangerous && cubit.role == 'child')
                IconButton(
                  icon: Icon(
                    device['status'] ? Icons.lock_open : Icons.lock,
                    color: device['status'] ? Colors.green : Colors.red,
                  ),
                  onPressed: () => _handleDeviceAction(context, device),
                ),
              if (!isDangerous || cubit.role == 'parent')
                Switch(
                  value: device['status'],
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.grey,
                  onChanged: (val) => cubit.updateDeviceStatus(context, device['id'], val),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDeviceAction(BuildContext context, Map<String, dynamic> device) {
    if (!device['status']) {
      context.read<DeviceCubit>().requestOTP(context, device['id'], device['name']);
    } else {
      context.read<DeviceCubit>().updateDeviceStatus(context, device['id'], false);
    }
  }
}