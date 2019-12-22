import 'package:flutter/cupertino.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';
import 'package:todo_list_for_doit_software/model/task_model.dart';
import 'package:todo_list_for_doit_software/service/task_service.dart';

class TaskRepository {
  TaskService _service = TaskService();

  Future<TaskModel> addNewTask(String title, String description,
      Priority priority, DateTime dueBy) async {
    TaskModel newTask = TaskModel(
        title: title,
        description: description,
        dueBy: dueBy,
        priority: priority);
    Map<String, dynamic> response = await _service.addNewTask(newTask);
    debugPrint(response.toString());
    newTask = newTask.taskFromJson(response['task']);

    return newTask;
  }

  Future<bool> deleteTask(int id) async {
    dynamic response = await _service.delete(id);

    if (response != null) {
      return true;
    }
    return false;
  }

  Future<List<TaskModel>> getAllTasks() async {
    List<TaskModel> tasks = [];
    List<dynamic> response = await _service.getAllTasks();
    debugPrint(response.toString());
    response.forEach((doc) {
      tasks.add(new TaskModel().taskFromJson(doc));
    });

    return tasks;
  }

  Future<void> updateTask(TaskModel currentTask) async {
    await _service.updateTask(currentTask);
  }
}
