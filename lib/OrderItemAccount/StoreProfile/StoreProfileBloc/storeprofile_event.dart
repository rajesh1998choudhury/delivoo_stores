import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NameChangedEvent extends ProfileEvent {
  final String? name;

  const NameChangedEvent({@required this.name});

  @override
  List<Object> get props => [name!];
}

class EmailChangedEvent extends ProfileEvent {
  final String? email;

  const EmailChangedEvent({@required this.email});

  @override
  List<Object> get props => [email!];
}

class SubmittedEvent extends ProfileEvent {
  final String? name;
  final String? email;

  SubmittedEvent({@required this.name, @required this.email});

  @override
  List<Object> get props => [name!, email!];
}
