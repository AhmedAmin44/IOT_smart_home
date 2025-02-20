import 'package:IOT_SmartHome/core/use_case/use_case.dart';
import 'package:IOT_SmartHome/features/user_setting/domain/entities/password_settings.dart';
import 'package:IOT_SmartHome/features/user_setting/domain/reposotories/password_repo.dart';

class PasswordUseCase implements UseCase<String,PasswordSettings>{
  final PasswordRepo passwordRepo;
  PasswordUseCase(this.passwordRepo);
  @override
  String call(PasswordSettings params) {
    return passwordRepo.generatePassword(params);
  }
} 