import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_block/services/authentication.dart';
import 'package:todo_block/services/todo_service.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationService _auth;
  final TodoService _todo;

  HomeBloc(this._auth, this._todo) : super(RegisteringServicesState()) {
    on<LoginEvent>((event, emitter) async {
      final user = await _auth.authenticateUser(event.userName, event.password);
      if (user != null) {
        emit(SuccessfullyLoginState(user));
        emit(HomeInitial());
      }
      //print(event);
    });
    on<RegisterAccountEvent>((event, emitter) async {
      final result = await _auth.createUser(event.userName, event.password);
      switch (result) {
        case UserCreationResult.success:
          emit(SuccessfullyLoginState(event.userName));
          break;
        case UserCreationResult.failure:
          emit(HomeInitial(error: "There's been an error"));
          break;
        case UserCreationResult.already_exists:
          emit(HomeInitial(error: "User already exists"));
          break;
      }
    });
    on<RegisterServiceEvent>((event, emitter) async {
      await _auth.init();
      await _todo.init();
      emit(HomeInitial());
    });
  }
}
