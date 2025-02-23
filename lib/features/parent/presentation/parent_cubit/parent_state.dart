abstract class ParentState {}

/// 🔹 **Initial State**
class ParentInitial extends ParentState {}

/// 🔹 **Dashboard Loaded**
class ParentLoaded extends ParentState {
  final String familyId;
  ParentLoaded({required this.familyId});
}

/// 🔹 **Device Operations**
class DeviceAddedSuccess extends ParentState {}

class DeviceDeletedSuccess extends ParentState {}

class DeviceStatusUpdated extends ParentState {}

class DeviceOperationFailure extends ParentState {
  final String error;
  DeviceOperationFailure({required this.error});
}

/// 🔹 **OTP Request Handling**
class OTPRequestApproved extends ParentState {}

class OTPRequestRejected extends ParentState {}
