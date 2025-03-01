import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/features/device/presentation/views/request_display_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String familyId;
  final String role;

  DeviceCubit({required this.familyId, required this.role}) : super(DeviceLoading()) {
    fetchDevices();
  }

  void fetchDevices() {
    _firestore
        .collection('devices')
        .where('familyId', isEqualTo: familyId)
        .snapshots()
        .listen((snapshot) {
      final devices = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'status': doc['status'],
          'isDangerous': doc['isDangerous'],
          'lastUsed': doc['lastUsed']?.toDate(),
        };
      }).toList();
      emit(DeviceLoaded(devices));
    }, onError: (error) {
      emit(DeviceError("Failed to load devices: $error"));
    });
  }

  String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> requestOTP(BuildContext context, String deviceId, String deviceName) async {
    if (role != 'child') {
      ShowToast('Only children can request OTP.')
      ;
      return;
    }
    var existing = await _firestore
        .collection('otp_requests')
        .where('deviceId', isEqualTo: deviceId)
        .where('childId', isEqualTo: familyId)
        .where('status', isEqualTo: 'pending')
        .get();
    if (existing.docs.isNotEmpty) {
            ShowToast('Request already pending for this device.');
      return;
    }
    String otp = _generateOTP();
    try {
      DocumentReference docRef = await _firestore.collection('otp_requests').add({
        'otp': otp,
        'childId': familyId,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'familyId': familyId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending'
      });
      GoRouter.of(context).go('/otpDisplay', extra: {
        'otpCode': otp,
        'role': role,
        'familyId': familyId,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'otpRequestId': docRef.id,
      });
    } catch (e) {
      emit(DeviceError("Failed to request OTP: $e"));
    }
  }

  Future<void> updateDeviceStatus(BuildContext context, String deviceId, bool newStatus) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({
        'status': newStatus,
        'lastUsed': FieldValue.serverTimestamp(),
      });
      fetchDevices();
      if (context.mounted) {
        ShowToast(' Device Updated!');
        
      }
    } catch (e) {
      if (context.mounted) {
        emit(DeviceError("Update Failed: ${e.toString()}"));
      }
    }
  }
}
