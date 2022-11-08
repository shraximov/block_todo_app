// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_block/services/todo_service.dart';
import 'package:todo_block/todos/block/todos_bloc.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo list"),
      ),
      body: BlocProvider(
        create: (context) =>
            TodosBloc(RepositoryProvider.of<TodoService>(context))
              ..add(LoadTodosEvent(userName)),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoadedState) {
              return ListView(
                children: [
                  ...state.tasks.map(
                    (e) => ListTile(
                      title: Text(e.task),
                      trailing: Checkbox(
                          value: e.completed,
                          onChanged: (val) {
                            BlocProvider.of<TodosBloc>(context)
                                .add(ToggleTodoEvent(e.task));
                          }),
                    ),
                  ),
                  ListTile(
                    title: const Text("Create new task"),
                    trailing: const Icon(Icons.add),
                    onTap: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => const Dialog(
                          child: CreateNewTask(),
                        ),
                      );
                      if (result != null) {
                        BlocProvider.of<TodosBloc>(context)
                            .add(AddTodosEvent(result));
                      }
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({Key? key}) : super(key: key);

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("What task do you want to create?"),
        TextField(
          controller: _inputController,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_inputController.text);
          },
          child: const Text("SAVE"),
        ),
      ],
    );
  }
}
