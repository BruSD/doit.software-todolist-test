import 'package:flutter/material.dart';
import 'package:todo_list_for_doit_software/global/prefs.dart';
import 'package:todo_list_for_doit_software/model/user_model.dart';
import 'package:todo_list_for_doit_software/repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  UserModel _userModel;

  final _repository = UserRepository();

  set loading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  get user => _userModel;

  bool get loading => this._isLoading;

  bool get isAuthenticated => this._userModel != null;

  Future<void> initUserFromLocalData() async {
    _userModel = new UserModel(
      userName: await Prefs.getUserName(),
      sessionID: await Prefs.getUserSessionID(),
    );
  }

  Future<bool> signIn(String login, String password) async {
    _userModel = await _repository.signIn(login, password);

    if (_userModel != null) {
      debugPrint(_userModel.sessionID);
      await Prefs.setUserSessionID(_userModel.sessionID);
      await Prefs.setUserName(_userModel.userName);

      loading = false;

      notifyListeners();

      return true;
    } else {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String login, String password) async {
    _userModel = await _repository.signUp(login, password);

    if (_userModel != null) {
      debugPrint(_userModel.sessionID);
      debugPrint(_userModel.sessionID);
      await Prefs.setUserSessionID(_userModel.sessionID);
      await Prefs.setUserName(_userModel.userName);

      loading = false;

      return true;
    } else {
      loading = false;

      return false;
    }
  }

  Future<bool> tryAutoLogin() async {
    if (!await Prefs.containsKey(Prefs.SESSION_TOKEN)) {
      return false;
    } else {
      _userModel = new UserModel(
          userName: await Prefs.getUserName(),
          sessionID: await Prefs.getUserSessionID());
      return true;
//      await serversProvider.getServers();
    }
  }

  Future<void> logOut() async {
    _userModel = null;

    await Prefs.logout();
    await _repository.logOut();
    notifyListeners();
  }

  String authError() {
    return _repository.error != null ? _repository.error : 'Unknown';
  }
}
