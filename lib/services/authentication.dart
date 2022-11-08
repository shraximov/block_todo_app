import 'package:hive/hive.dart';
import 'package:todo_block/models/user_model.dart';

class AuthenticationService {
  late Box<UserModel> _users;

  Future<void> init() async {
    Hive.registerAdapter(UserModelAdapter());
    _users = await Hive.openBox<UserModel>('usersBox');

    await _users.add(UserModel('testUser1', '123456'));
    await _users.add(UserModel('shraximov', '123456'));
  }

  Future<String?> authenticateUser(
      final String userName, final String password) async {
    final success = _users.values.any((element) =>
        element.userName == userName && element.password == password);
    if (success) {
      return userName;
    } else {
      return null;
    }
  }

  Future<UserCreationResult> createUser(
      String userName, String password) async {
    final alreadyExists = _users.values.any(
        (element) => element.userName.toLowerCase() == userName.toLowerCase());
    if (alreadyExists) {
      return UserCreationResult.already_exists;
    }

    try {
      _users.add(UserModel(userName, password));
      return UserCreationResult.success;
    } on Exception catch (ex) {
      return UserCreationResult.failure;
    }
  }
}

enum UserCreationResult {
  success,
  failure,
  already_exists,
}
