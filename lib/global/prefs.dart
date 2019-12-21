import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String SESSION_TOKEN = "SESSION_TOKEN";
  static const String USER_NAME = "USER_NAME";

  static final _prefs = SharedPreferences.getInstance();

//Session Preference
  static Future<void> setUserSessionID(String sessionID) async {
    (await _prefs).setString(SESSION_TOKEN, sessionID);
  }

  static Future<String> getUserSessionID() async {
    return (await _prefs).getString(SESSION_TOKEN);
  }

  static Future<bool> removeUserSessionID() async {
    return (await _prefs).remove(SESSION_TOKEN);
  }

  //Session Preference

  static Future<void> setUserName(String userName) async {
    (await _prefs).setString(USER_NAME, userName);
  }

  static Future<String> getUserName() async {
    return (await _prefs).getString(USER_NAME);
  }

  static Future<bool> removeUserName() async {
    return (await _prefs).remove(USER_NAME);
  }

//  Global
  static Future<bool> containsKey(String key) async {
    return (await _prefs).containsKey(key);
  }

  static Future<void> logout() async {
    await removeUserSessionID();
    await removeUserName();
  }
}
