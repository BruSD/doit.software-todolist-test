import 'package:flutter/cupertino.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';
import 'package:todo_list_for_doit_software/model/task_model.dart';
import 'package:todo_list_for_doit_software/service/task_service.dart';

class TaskRepository {
  TaskService _service = TaskService();

  Future<TaskModel> addNewTask(
      String title, String description, Priority priority, DateTime dueBy) async {
    TaskModel newTask = TaskModel(
        title: title,
        description: description,
        dueBy: dueBy,
        priority: priority);
    Map<String, dynamic> response = await _service.addNewTask(newTask);
    debugPrint(response.toString());

    return newTask;
  }
}
