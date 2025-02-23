
import 'package:IOT_SmartHome/features/parent/presentation/parent_cubit/parent_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentCubit extends Cubit<ParentState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ParentCubit() : super(ParentInitial());

  void initialize({required String familyId}) {
    emit(ParentLoaded(familyId: familyId));
  }

  Future<void> addDevice(String familyId, String name, bool isDangerous) async {
    try {
      await _firestore.collection('devices').add({
        'name': name,
        'status': false,
        'isDangerous': isDangerous,
        'familyId': familyId,
        'lastUsed': FieldValue.serverTimestamp(),
      });
      emit(DeviceAddedSuccess());
    } catch (e) {
      emit(DeviceAddedFailure());
    }
  }

  Stream<List<Map<String, dynamic>>> getDevices(String familyId) {
    return _firestore
        .collection('devices')
        .where('familyId', isEqualTo: familyId)
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

  Future<void> toggleDeviceStatus(String deviceId, bool status) async {
    await _firestore.collection('devices').doc(deviceId).update({'status': status});
  }

  Future<void> deleteDevice(String deviceId) async {
    await _firestore.collection('devices').doc(deviceId).delete();
  }
}


