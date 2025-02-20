import 'dart:math';
import 'package:IOT_SmartHome/features/user_setting/domain/entities/password_settings.dart';

class PasswordGenerate {
  final Map<String, String> _characters = {
    "lowercase": "abcdefghijklmnopqrstvwxyz",
    "uppercase": "ABCDEFGHIJKLMNOPQRSTVWXYZ",
    "numbers": "0123456789",
    "symbols": "!@#.%^&*(){}?:;+><,"
  };

  String generatePassword(PasswordSettings passwordsettings) {
    String staticPassword = "", randomPassword = "";

    if (passwordsettings.isLowerCase) {
      staticPassword += _characters["lowercase"]!;
    }
    if (passwordsettings.isUpperCase) {
      staticPassword += _characters["uppercase"]!;
    }
    if (passwordsettings.isNumbers) {
      staticPassword += _characters["numbers"]!;
    }
    if (passwordsettings.symbols) {
      staticPassword += _characters["symbols"]!;
    }
    if (passwordsettings.isIncludeSpaces) {
      staticPassword += " $staticPassword ";
    }

    // **Fix: Check if staticPassword is empty before proceeding**
    if (staticPassword.isEmpty) {
      throw Exception("No character set selected for password generation.");
    }

    for (var i = 0; i < passwordsettings.passwordLength; i++) {
      var randomChar = staticPassword[
          (Random().nextDouble() * staticPassword.length).floor()];

      if (passwordsettings.isExcludeDuplicate) {
        if (!randomPassword.contains(randomChar) || randomChar == " ") {
          randomPassword += randomChar;
        } else {
          i--; // Re-attempt character selection
        }
      } else {
        randomPassword += randomChar;
      }
    }
    return randomPassword;
  }
}
