import 'package:equatable/equatable.dart';

class SupportEvent extends Equatable {
  final String name;
  final String email;
  final String message;

  SupportEvent(this.name, this.email, this.message);
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
