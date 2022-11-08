part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();
}

class LoadTodosEvent extends TodosEvent {
  final String userName;

  const LoadTodosEvent(this.userName);

  @override
  // TODO: implement props
  List<Object?> get props => [userName];
}

class AddTodosEvent extends TodosEvent {
  final String todoTask;

  const AddTodosEvent(this.todoTask);

  @override
  // TODO: implement props
  List<Object?> get props => [todoTask];
}

class ToggleTodoEvent extends TodosEvent {
  final String todoTask;

  const ToggleTodoEvent(this.todoTask);

  @override
  // TODO: implement props
  List<Object?> get props => [todoTask];
}
