import 'package:todo_list_for_doit_software/model/user_model.dart';
import 'package:todo_list_for_doit_software/service/user_service.dart';

class UserRepository {
  String error;
  final service = UserService();

  Future<UserModel> signIn(login, password) async {
    Map<String, dynamic> response = await service.signIn(login, password);

    if (response['success'] == true) {
      return new UserModel(
        sessionID: response['token'],
        userName: login,
      );
    } else {
      error = response['error'];
      return null;
    }
  }

  Future<UserModel> signUp(login, password) async {
    Map<String, dynamic> response = await service.signUp(login, password);

    if (response != null) {
      return new UserModel(
        sessionID: response['token'],
        userName: login,
      );
    } else {
      error = response.toString();
      return null;
    }
  }

  Future<dynamic> logOut() async {
    return await service.logout();
  }
}
