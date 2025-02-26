import 'package:IOT_SmartHome/features/device/presentation/device_cubit/device_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

            ////handel the type here  ---------> with (cubit) 
            device['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          subtitle: Text(
            'Status: ${device['status'] ? 'On' : 'Off'}\n'
            'Last used: ${device['lastUsed'] != null ? device['lastUsed'].toString().substring(0, 16) : 'Never'}'
            ,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDangerous && cubit.role == 'child')
                IconButton(

                  /// and icon here    ---------> with (cubit) 
                  icon: const Icon(Icons.lock, color: Colors.red),
                  onPressed: () => cubit.requestOTP(context, device['id'], device['name']),
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
}
