abstract class ParentState {}

class ParentInitial extends ParentState {}

class ParentLoaded extends ParentState {
  final String familyId;
  ParentLoaded({required this.familyId});
}

class DeviceAddedSuccess extends ParentState {}

class DeviceAddedFailure extends ParentState {}