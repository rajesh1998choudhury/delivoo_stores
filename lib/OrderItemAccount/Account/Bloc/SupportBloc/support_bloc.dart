// ignore_for_file: override_on_non_overriding_member, unnecessary_type_check

import 'package:delivoo_stores/OrderItemAccount/Account/Bloc/SupportBloc/support_event.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/Bloc/SupportBloc/support_state.dart';
import 'package:delivoo_stores/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  Repository _repository = Repository();

  SupportBloc(SupportState initialState) : super(initialState);

  @override
  SupportState get initialState => SupportState();

  @override
  Stream<SupportState> mapEventToState(SupportEvent event) async* {
    if (event is SupportEvent) {
      yield* _mapPostSupportToState(event.name, event.email, event.message);
    }
  }

  Stream<SupportState> _mapPostSupportToState(
      String name, String email, String message) async* {
    try {
      await _repository.support(name, email, message);
      yield SupportState();
    } catch (e) {
      throw Exception();
    }
  }
}
