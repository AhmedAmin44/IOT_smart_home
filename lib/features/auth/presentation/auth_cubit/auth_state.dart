class AuthState {}

final class AuthInitial extends AuthState {}

final class SignUpLoadingState extends AuthState {}

final class SignUpSuccessState extends AuthState {}

final class SignUpFailureState extends AuthState {
  final String errmsg;
  SignUpFailureState({required this.errmsg});
}
final class PhoneVerificationSuccessState extends AuthState {}
final class OTPCodeSentState extends AuthState {}
final class PhoneVerificationFailureState extends AuthState {
    final String errmsg;

  PhoneVerificationFailureState({required this.errmsg});

}


final class SignInLoadingState extends AuthState {}

final class SignInSuccessState extends AuthState {
  final String role;
  final String familyId;
  SignInSuccessState({required this.role, required this.familyId});
}
final class SignInFailureState extends AuthState{
  final String errMsg;
  SignInFailureState({required this.errMsg});
}final class ResetPasswordLoadingState extends AuthState {}

final class ResetPasswordSuccessState extends AuthState {}
final class ResetPasswordFailureState extends AuthState{
  final String errMsg;
  ResetPasswordFailureState({required this.errMsg});
}

final class TermsAndConditionsChekBoxState extends AuthState {}

final class ObscurePasswordTextUpdateState extends AuthState {}

class ParentDashboardState extends AuthState {
  final String role;
  ParentDashboardState({required this.role});
}
class ChildDashboardState extends AuthState {}
class InviteSentSuccessState extends AuthState {}
class OperationFailureState extends AuthState {
  final String errMsg;
  OperationFailureState({required this.errMsg});
}
class OTPGeneratedState extends AuthState {
  final String otp;
  OTPGeneratedState({required this.otp});
}
class RequestApprovalSuccessState extends AuthState {}
class RequestApprovalFailureState extends AuthState {
  final String errMsg;
  RequestApprovalFailureState({required this.errMsg});
}
class PhoneCodeSentState extends AuthState {}
