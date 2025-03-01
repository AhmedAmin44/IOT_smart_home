part of 'family_cubit.dart';

abstract class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilyRoleChanged extends FamilyState {
  final String newRole;
  FamilyRoleChanged(this.newRole);
}

class FamilyMemberAdded extends FamilyState {}

class FamilyMemberRemoved extends FamilyState {
  final String userId;
  FamilyMemberRemoved(this.userId);
}

class FamilyMemberUpdated extends FamilyState {
  final String userId;
  final String firstName;
  final String lastName;
  final String role;

  FamilyMemberUpdated(this.userId, this.firstName, this.lastName, this.role);
}
