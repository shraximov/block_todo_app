import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_block/home/block/home_bloc.dart';
import 'package:todo_block/services/authentication.dart';
import 'package:todo_block/services/todo_service.dart';
import 'package:todo_block/todos/todos.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login to ToDo app"),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(
          RepositoryProvider.of<AuthenticationService>(context),
          RepositoryProvider.of<TodoService>(context),
        )..add(RegisterServiceEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessfullyLoginState) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TodosPage(userName: state.userName),
                ),
              );
            }
            if (state is HomeInitial) {
              if (state.error != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(state.error ?? ''),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              return Column(
                children: [
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                            LoginEvent(userNameController.text.trim(),
                                passwordController.text.trim())),
                        child: const Text("LOGIN"),
                      ),
                      const SizedBox(width: 50),
                      ElevatedButton(
                        onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                          RegisterAccountEvent(
                            userNameController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        ),
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
