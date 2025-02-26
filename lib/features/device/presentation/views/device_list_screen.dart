import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:IOT_SmartHome/features/device/presentation/device_cubit/device_cubit.dart';
import 'package:IOT_SmartHome/features/device/presentation/widgets/device_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class DeviceListScreen extends StatelessWidget {
  final String familyId;
  final String role;

  const DeviceListScreen({Key? key, required this.familyId, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceCubit(familyId: familyId, role: role),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text("Devices ",
              style: CustomTextStyles.pacifico400style64
                  .copyWith(fontSize: 25, color: AppColors.primaryColor)),
          leading: Icon(
            FontAwesomeIcons.lightbulb,
            color: Colors.green,
            size: 28,
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DeviceCubit, DeviceState>(
          builder: (context, state) {
            if (state is DeviceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DeviceError) {
              return Center(child: Text(state.message));
            } else if (state is DeviceLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0,vertical: 25),
                child: DeviceListView(devices: state.devices),
              );
            }
            return const Center(child: Text('No devices found'));
          },
        ),
      ),
    );
  }
}
