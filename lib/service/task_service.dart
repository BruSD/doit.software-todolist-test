import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';
import 'package:todo_list_for_doit_software/global/prefs.dart';
import 'package:todo_list_for_doit_software/model/task_model.dart';

class TaskService {
  Future<Map<String, dynamic>> addNewTask(TaskModel newTask) async {
    var response = await Requests.post(TASKS_URL,
        headers: {'Authorization': 'Bearer ' + await Prefs.getUserSessionID()},
        body: newTask.toJson(),
        bodyEncoding: RequestBodyEncoding.FormURLEncoded);
    debugPrint(response.content());

    if (response.statusCode == 201) {
      debugPrint('Add Task responce ' + response.content().toString());
      return json.decode(response.content());
    } else {
      return null;
    }
  }
}