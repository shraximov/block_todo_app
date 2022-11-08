import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_block/models/task_model.dart';
import 'package:todo_block/services/todo_service.dart';

part 'todos_event.dart';

part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoService _todoService;

  TodosBloc(this._todoService) : super(TodosInitial()) {
    on<LoadTodosEvent>((event, emit) async {
      final todos = await _todoService.getTasks(event.userName);
      emit(TodosLoadedState(todos, event.userName));
    });
    on<AddTodosEvent>((event, emitter) async {
      final currentState = state as TodosLoadedState;
      _todoService.addTask(event.todoTask, currentState.userName);
      add(LoadTodosEvent(currentState.userName));
    });
    on<ToggleTodoEvent>((event, emit) async {
      final currentState = state as TodosLoadedState;
      await _todoService.updateTask(event.todoTask, currentState.userName);
      add(LoadTodosEvent(currentState.userName));
    });
  }
}
