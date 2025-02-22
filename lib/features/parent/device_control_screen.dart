import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import '../../core/function/custom_troast.dart';
import '../../core/widgets/customButton.dart';
import '../auth/presentation/auth_cubit/auth_cubit.dart';

class DeviceControlScreen extends StatefulWidget {
  final String role;
  final String familyId;
  
  const DeviceControlScreen({
    Key? key,
    required this.role,
    required this.familyId,
  }) : super(key: key);

  @override
  _DeviceControlScreenState createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  final TextEditingController _newDeviceController = TextEditingController();
  bool _isDangerous = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add device to Firestore
  Future<bool> _addDevice(String name, bool isDangerous) async {
    try {
      await _firestore.collection('devices').add({
        'name': name,
        'status': false,
        'isDangerous': isDangerous,
        'familyId': widget.familyId,
        'lastUsed': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error adding device: $e");
      return false;
    }
  }

  // Get devices stream from Firestore
  Stream<List<Map<String, dynamic>>> _getDevices() {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: widget.familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['name'],
                  'status': doc['status'],
                  'isDangerous': doc['isDangerous'],
                  'lastUsed': doc['lastUsed']?.toDate(),
                })
            .toList());
  }

  // Show add device dialog
  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Device'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newDeviceController,
              decoration: const InputDecoration(
                hintText: 'Enter device name',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Is Dangerous?'),
                Switch(
                  value: _isDangerous,
                  onChanged: (value) => setState(() => _isDangerous = value),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_newDeviceController.text.isNotEmpty) {
                final success = await _addDevice(
                  _newDeviceController.text,
                  _isDangerous,
                );
                
                if (success) {
                  _newDeviceController.clear();
                  Navigator.pop(context);
                  ShowToast('Device added successfully!');
                } else {
                  ShowToast('Failed to add device');
                }
              } else {
                ShowToast('Please enter device name');
              }
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newDeviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()
        ..initialize(
          familyId: widget.familyId,
          role: widget.role,
        ),
      child: Scaffold(
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
              // Add Device Button
              CustomBotton(
                text: "Add New Device!",
                onPressed: _showAddDeviceDialog,
              ),
              const SizedBox(height: 20),
              
              // Devices List
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _getDevices(),
                  builder: (context, snapshot) {
                    // Loading State
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Error State
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // Empty State
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No devices found'));
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
                                // Status Switch
                                Switch(
                                  value: device['status'],
                                  activeColor: Colors.green,
                                  inactiveTrackColor: Colors.grey,
                                  onChanged: (value) async {
                                    await _firestore
                                        .collection('devices')
                                        .doc(device['id'])
                                        .update({'status': value});
                                    ShowToast(
                                        '${device['name']} turned ${value ? 'On' : 'Off'}');
                                  },
                                ),
                                
                                // Delete Button
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    await _firestore
                                        .collection('devices')
                                        .doc(device['id'])
                                        .delete();
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}