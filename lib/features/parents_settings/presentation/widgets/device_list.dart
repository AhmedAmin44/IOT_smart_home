import 'package:IOT_SmartHome/features/parents_settings/presentation/parent_cubit/parent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/function/custom_troast.dart';

class DeviceList extends StatelessWidget {
  final String familyId;

  const DeviceList({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentCubit = context.read<ParentCubit>();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: parentCubit.getDevices(familyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No devices found',style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
             ));
        }

        final devices = snapshot.data!;

        return ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];

            return Card(
              color: AppColors.secColor,
              child: ListTile(
                title: Text(
                  device['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                subtitle: Text(
                  'Status: ${device['status'] ? 'On' : 'Off'}\n'
                  'Last used: ${device['lastUsed']?.toString() ?? 'Never'}',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: device['status'],
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (value) {
                        parentCubit.toggleDeviceStatus(device['id'], value);
                        ShowToast('${device['name']} turned ${value ? 'On' : 'Off'}');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                      onPressed: () {
                        parentCubit.deleteDevice(device['id']);
                        ShowToast('${device['name']} deleted');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
