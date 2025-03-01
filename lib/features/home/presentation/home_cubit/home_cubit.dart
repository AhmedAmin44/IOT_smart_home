import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  XFile? profilePic;

  

  /// 🔹 Fetch FirstName from Firestore
  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'User';

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return 'User';

    return userDoc.data()?['firstname'] ?? 'User';
  }

  
  
// not now
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Future.delayed(Duration(milliseconds: 500), () {
        SystemNavigator.pop();
      });
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(HomeLogOutError(errorMsg: "Logout failed: $e"));
    }
  }
}
