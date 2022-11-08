part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoginEvent extends HomeEvent {
  final String userName;
  final String password;

  LoginEvent(this.userName, this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [userName, password];
}

class RegisterServiceEvent extends HomeEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RegisterAccountEvent extends HomeEvent {
  final String userName;
  final String password;

  RegisterAccountEvent(this.userName, this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [userName, password];
}
