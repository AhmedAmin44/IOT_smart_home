import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/features/parents_settings/presentation/parent_cubit/parent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/function/custom_troast.dart';

class AddDeviceDialog extends StatefulWidget {
  final String familyId;

  const AddDeviceDialog({Key? key, required this.familyId}) : super(key: key);

  @override
  _AddDeviceDialogState createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? isDanger;

  @override
  void dispose() {
    _typeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
              color: AppColors.secColor,

        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: BlocProvider.value(
        value: BlocProvider.of<ParentCubit>(context),
        child: StatefulBuilder(
          builder: (context, setState) {
            final parentCubit = context.read<ParentCubit>();

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const Text(
                    "Add New Device",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Device Type Field
                  _buildTextField(_typeController, "Enter Device Type"),
                  const SizedBox(height: 10),

                  // Device Name Field
                  _buildTextField(_nameController, "Enter Device Name"),
                  const SizedBox(height: 10),

                  // Is Dangerous Dropdown
                  DropdownButtonFormField<String>(
                    value: isDanger,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    items: ["Yes", "No"].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.green)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => isDanger = value);
                    },
                    decoration: InputDecoration(
                      labelText: "Is Danger?",
                      labelStyle: const TextStyle(color: Colors.red),
                      filled: true,
                      fillColor: Colors.green.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Colors.green)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () async {
                          String type = _typeController.text.trim();
                          String name = _nameController.text.trim();

                          if (type.isEmpty || name.isEmpty || isDanger == null) {
                            ShowToast("Please fill all fields");
                            return;
                          }

                          await parentCubit.addDevice(
                            widget.familyId,
                            "$type - $name",
                            isDanger == "Yes",
                          );

                          Navigator.pop(context);
                          ShowToast("Device added successfully!");
                        },
                        child: const Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🔥 Reusable TextField Widget
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.green.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
