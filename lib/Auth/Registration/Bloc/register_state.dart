import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool? isNameValid;
  final bool? isEmailValid;
  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;
  final bool? isServerError;

  bool get isFormValid => isNameValid! && isEmailValid!;

  RegisterState({
    @required this.isNameValid,
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isServerError,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isNameValid: true,
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isServerError: false,
    );
  }
  factory RegisterState.loading() {
    return RegisterState(
      isNameValid: true,
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isServerError: false,
    );
  }
  factory RegisterState.success() {
    return RegisterState(
      isNameValid: true,
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isServerError: false,
    );
  }
  factory RegisterState.failure({
    @required bool? isNameValid,
    @required bool? isEmailValid,
    @required bool? isServerError,
  }) {
    return RegisterState(
      isNameValid: isNameValid,
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isServerError: isServerError,
    );
  }

  RegisterState update({
    bool? isNameValid,
    bool? isEmailValid,
  }) {
    return copyWith(
      isNameValid: isNameValid!,
      isEmailValid: isEmailValid!,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool? isNameValid,
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return RegisterState(
      isNameValid: isNameValid ?? this.isNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isServerError: isFailure ?? this.isServerError,
    );
  }

  @override
  String toString() {
    return 'RegisterState{isNameValid: $isNameValid, isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
