// ignore_for_file: override_on_non_overriding_member

import 'package:bloc/bloc.dart';
import 'package:delivoo_stores/Auth/Registration/Bloc/validators.dart';
import 'package:delivoo_stores/OrderItemAccount/StoreProfile/StoreProfileBloc/storeprofile_event.dart';
import 'package:delivoo_stores/OrderItemAccount/StoreProfile/StoreProfileBloc/storeprofile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(ProfileState initialState) : super(initialState);

  @override
  ProfileState get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChangedEvent) {
      yield _mapNameChangedToState(event.name!);
    } else if (event is EmailChangedEvent) {
      yield _mapEmailChangedToState(event.email!);
    } else if (event is SubmittedEvent) {
      yield* _mapFormSubmittedToState(event.name!, event.email!);
    }
  }

  ProfileState _mapNameChangedToState(String name) {
    return state.update(isNameValid: Validators.isNameValid(name));
  }

  ProfileState _mapEmailChangedToState(String email) {
    return state.update(isNameValid: Validators.isEmailValid(email));
  }

  Stream<ProfileState> _mapFormSubmittedToState(
      String name, String email) async* {
    yield ProfileState.loading();

    var nameValid = Validators.isNameValid(name);
    var emailValid = Validators.isEmailValid(email);

    bool isValid = nameValid && emailValid;

    if (isValid) {
      yield ProfileState.success();
    } else {
      yield ProfileState.failure(
          isNameValid: nameValid, isEmailValid: emailValid);
    }
  }
}
