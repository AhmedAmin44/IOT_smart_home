import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/features/user_setting/domain/entities/password_settings.dart';
import 'package:IOT_SmartHome/features/user_setting/domain/use_cases/password_use_case.dart';

part 'setting_state.dart';

class PasswordGenerateCubit extends Cubit<PasswordGenerateState> {
  final PasswordUseCase passwordUseCase;
  PasswordGenerateCubit(this.passwordUseCase)
      : super(PasswordGenerateState.initial());

  void changePasswordLength(int passwordLength) {
    emit(state.copyWith(passwordLength: passwordLength));
  }

  void toggleLowerCase() {
    emit(state.copyWith(isLowerCase: !state.isLowerCase));
  }

  void toggleUpperCase() {
    emit(state.copyWith(isUpperCase: !state.isUpperCase));
  }

  void toggleNumbers() {
    emit(state.copyWith(isNumbers: !state.isNumbers));
  }

  void toggleSymbols() {
    emit(state.copyWith(isSymbols: !state.isSymbols));
  }

  void toggleExcludeDuplicate() {
    emit(state.copyWith(isExcludeDuplicate: !state.isExcludeDuplicate));
  }

  void toggleIncludeSpaces() {
    emit(state.copyWith(isIncludeSpaces: !state.isIncludeSpaces));
  }

  void updateMaxPasswordLength() {
    final max = getMaxPasswordLength(state);
    emit(state.copyWith(
        passwordLength: state.passwordLength > max ? max : state.passwordLength,
        maxPasswordLength: max));
  }

  void generatePassword() {
    var params = PasswordSettings(
        isExcludeDuplicate: state.isExcludeDuplicate,
        isLowerCase: state.isLowerCase,
        isNumbers: state.isNumbers,
        isIncludeSpaces: state.isIncludeSpaces,
        isUpperCase: state.isUpperCase,
        passwordLength: state.passwordLength,
        symbols: state.isSymbols);
    var randomPassword = passwordUseCase.call(params);
    emit(state.copyWith(password: randomPassword));
  }

  void updateSettings({
    required int passwordLength,
    required bool isLowerCase,
    required bool isUpperCase,
    required bool isNumbers,
    required bool isSymbols,
    required bool isExcludeDuplicate,
    required bool isIncludeSpaces,
  }) {
    emit(state.copyWith(
      passwordLength: passwordLength,
      isLowerCase: isLowerCase,
      isUpperCase: isUpperCase,
      isNumbers: isNumbers,
      isSymbols: isSymbols,
      isExcludeDuplicate: isExcludeDuplicate,
      isIncludeSpaces: isIncludeSpaces,
    ));
  }

  void updateRemainingTime(int remainingTime) {
    emit(state.copyWith(remainingTime: remainingTime));
  }

  int getMaxPasswordLength(PasswordGenerateState state) {
    var maxPasswordLength = 1;
    if (state.isLowerCase) maxPasswordLength += 4;
    if (state.isUpperCase) maxPasswordLength += 4;
    if (state.isNumbers) maxPasswordLength += 4;
    if (state.isSymbols) maxPasswordLength += 4;
    if (state.isIncludeSpaces) maxPasswordLength += 2;
    return maxPasswordLength;
  }

  //Admin settings
  Future<void> saveSettings() async {
    try {
      // Count how many boolean values are true
      int trueCount = [
        state.isLowerCase,
        state.isUpperCase,
        state.isNumbers,
        state.isSymbols,
        state.isExcludeDuplicate,
        state.isIncludeSpaces,
      ].where((value) => value == true).length;

      // Ensure at least 2 options are selected
      if (trueCount < 2) {
        print("Error: At least 2 settings must be enabled before saving.");
        return;
      }

      await FirebaseFirestore.instance
          .collection('settings')
          .doc('passwordSettings')
          .set({
        'passwordLength': state.passwordLength,
        'isLowerCase': state.isLowerCase,
        'isUpperCase': state.isUpperCase,
        'isNumbers': state.isNumbers,
        'isSymbols': state.isSymbols,
        'isExcludeDuplicate': state.isExcludeDuplicate,
        'isIncludeSpaces': state.isIncludeSpaces,
      });

      print("Settings saved successfully");
    } catch (e) {
      print("Error saving settings: $e");
    }
  }

  Future<void> loadSettings() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('passwordSettings')
          .get();
      if (doc.exists) {
        var data = doc.data()!;
        print('Settings loaded: $data');

        emit(state.copyWith(
          passwordLength: data['passwordLength'] ?? 10,
          isLowerCase: data['isLowerCase'] ?? false,
          isUpperCase: data['isUpperCase'] ?? false,
          isNumbers: data['isNumbers'] ?? false,
          isSymbols: data['isSymbols'] ?? false,
          isExcludeDuplicate: data['isExcludeDuplicate'] ?? false,
          isIncludeSpaces: data['isIncludeSpaces'] ?? false,
        ));

        print("Settings loaded successfully");
      } else {
        print("No settings found in Firebase");
      }
    } catch (e) {
      print("Error loading settings: $e");
    }
  }
}
