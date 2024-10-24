import 'package:meta/meta.dart';

@immutable
class VerificationState {
  final bool ?isOtpValid;
  final bool ?isSubmitting;
  final bool ?isSuccess;
  final bool ?isFailure;

  VerificationState({
    @required this.isOtpValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory VerificationState.empty() {
    return VerificationState(
      isOtpValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory VerificationState.invalidOtp() {
    return VerificationState(
      isOtpValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory VerificationState.loading() {
    return VerificationState(
      isOtpValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory VerificationState.success() {
    return VerificationState(
      isOtpValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory VerificationState.failure() {
    return VerificationState(
      isOtpValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  @override
  String toString() {
    return 'VerificationState{isOtpValid: $isOtpValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
