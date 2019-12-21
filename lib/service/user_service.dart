import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';

class UserService {
  Future<Map<String, dynamic>> signIn(String login, String password) async {
    final loginURL = SIGN_IN_URL;

    var response = await Requests.post(loginURL);

    if (response.statusCode == 200) {
      debugPrint(response.content());

      return json.decode(response.content());
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> signUp(String login, String password) async {
    var response = await Requests.post(SIGN_UP_URL,
        body: {
          "email": login,
          "password": password,
        },
        bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    debugPrint(response.content());

    if (response.statusCode == 201) {
      debugPrint('Sign Up responce: ' + response.content().toString());
      return json.decode(response.content());
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> logout() async {
//    var response = await Requests.post(logoutAPI);
    return null; //json.decode(response.content());
  }
}
