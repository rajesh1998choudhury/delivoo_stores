import 'package:meta/meta.dart';

@immutable
class ProfileState {
  final bool? isNameValid;
  final bool? isEmailValid;
  final bool? isSubmitting;
  final bool? isSuccess;
  final bool? isFailure;

  bool get isFormValid => isNameValid! && isEmailValid!;

  ProfileState({
    @required this.isNameValid,
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory ProfileState.empty() {
    return ProfileState(
      isNameValid: true,
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory ProfileState.loading() {
    return ProfileState(
      isNameValid: true,
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory ProfileState.success() {
    return ProfileState(
      isNameValid: true,
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }
  factory ProfileState.failure({
    @required bool? isNameValid,
    @required bool? isEmailValid,
  }) {
    return ProfileState(
      isNameValid: isNameValid,
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  ProfileState update({
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

  ProfileState copyWith({
    bool?isNameValid,
    bool ?isEmailValid,
    bool ?isSubmitting,
    bool ?isSuccess,
    bool ?isFailure,
  }) {
    return ProfileState(
      isNameValid: isNameValid ?? this.isNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return 'ProfileState{isNameValid: $isNameValid, isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
