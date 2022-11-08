import 'package:hive/hive.dart';
import 'package:todo_block/models/task_model.dart';

class TodoService {
  late Box<TaskModel> _tasks;

  Future<void> init() async {
    Hive.registerAdapter(TaskModelAdapter());
    _tasks = await Hive.openBox<TaskModel>('tasks');

    await _tasks.clear();
    _tasks.add(TaskModel('testUser1', "Test qilib korvomman", true));
    _tasks.add(TaskModel('shraximov', "Test qilib korvomman dedimku", false));
  }

  Future<List<TaskModel>> getTasks(String userName) async {
    final tasks = _tasks.values.where((element) => element.user == userName);
    return tasks.toList();
  }

  void addTask(String task, String userName) {
    _tasks.add(TaskModel(userName, task, false));
  }

  Future<void> removeTask(String task, String userName) async {
    final taskToRemove = _tasks.values.firstWhere(
        (element) => element.user == userName && element.task == task);
    await taskToRemove.delete();
  }

  Future<void> updateTask(String task, String userName) async {
    final taskToEdit = _tasks.values.firstWhere(
        (element) => element.user == userName && element.task == task);
    final index = taskToEdit.key as int;
    await _tasks.put(index, TaskModel(userName, task, !taskToEdit.completed));
  }
}
