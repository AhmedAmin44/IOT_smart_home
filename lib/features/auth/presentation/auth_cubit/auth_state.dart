abstract class AuthState {}

class AuthInitial extends AuthState {}
class SignUpLoadingState extends AuthState {}
class SignUpSuccessState extends AuthState {}
class SignUpFailureState extends AuthState {
  final String errmsg;
  SignUpFailureState({required this.errmsg});
}
class SignInLoadingState extends AuthState {}
class SignInFailureState extends AuthState {
  final String errMsg;
  SignInFailureState({required this.errMsg});
}
class SignInSuccessState extends AuthState {
  final String role;
  final String familyId;
  SignInSuccessState({required this.role, required this.familyId});
}
class PhoneCodeSentState extends AuthState {}
class PhoneVerificationSuccessState extends AuthState {}
class InviteSentSuccessState extends AuthState {}
class OperationFailureState extends AuthState {
  final String errMsg;
  OperationFailureState({required this.errMsg});
}
class OperationSuccessState extends AuthState {}
class OTPGeneratedState extends AuthState {
  final String otp;
  OTPGeneratedState({required this.otp});
}
class RequestApprovalSuccessState extends AuthState {}
class RequestApprovalFailureState extends AuthState {
  final String errMsg;
  RequestApprovalFailureState({required this.errMsg});
}
class ResetPasswordLoadingState extends AuthState {}
class ResetPasswordSuccessState extends AuthState {}
class ResetPasswordFailureState extends AuthState {
  final String errMsg;
  ResetPasswordFailureState({required this.errMsg});
}
class TermsAndConditionsCheckBoxState extends AuthState {}
class ObscurePasswordTextUpdateState extends AuthState {}