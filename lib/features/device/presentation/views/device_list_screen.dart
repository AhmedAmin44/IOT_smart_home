import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import '../device_cubit/device_cubit.dart';
import '../widgets/device_list_view.dart';

class DeviceListScreen extends StatelessWidget {
  final String familyId;
  final String role;

  const DeviceListScreen({super.key, required this.familyId, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceCubit(familyId: familyId, role: role)..fetchDevices(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "Smart Devices",
            style: CustomTextStyles.pacifico400style64.copyWith(
              fontSize: 25,
              color: AppColors.primaryColor,
            ),
          ),
          leading: const Icon(FontAwesomeIcons.lightbulb, color: Colors.green, size: 28),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<DeviceCubit, DeviceState>(
      listener: (context, state) {
        if (state is DeviceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is DeviceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DeviceLoaded) {
          return RefreshIndicator(
            onRefresh: () async => context.read<DeviceCubit>().fetchDevices(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 25),
              child: DeviceListView(devices: state.devices),
            ),
          );
        }
        return const Center(child: Text('No devices found'));
      },
    );
  }
}
