import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/parent/presentation/parent_cubit/parent_cubit.dart';
import 'package:IOT_SmartHome/features/parent/presentation/widgets/add_device_dialog.dart';
import 'package:IOT_SmartHome/features/parent/presentation/widgets/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class DeviceControlScreen extends StatelessWidget {
  final String role;
  final String familyId;

  const DeviceControlScreen({
    Key? key,
    required this.role,
    required this.familyId,
  }) : super(key: key);

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomBotton(
  text: "Add New Device!",
  onPressed: () => showModalBottomSheet(
    context: context,
     isScrollControlled: true,
   
    builder: (dialogContext) => BlocProvider.value(
      value: BlocProvider.of<ParentCubit>(context), 
      child: AddDeviceDialog(familyId: familyId),
    ),
  ),
),

            const SizedBox(height: 20),
            Expanded(child: DeviceList(familyId: familyId)),
          ],
        ),
      ),
    );
  }
}
