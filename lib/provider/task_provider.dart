import 'package:flutter/material.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';
import 'package:todo_list_for_doit_software/model/task_model.dart';
import 'package:todo_list_for_doit_software/repository/task_repository.dart';

class TaskProvider with ChangeNotifier {
  TaskRepository _repository = TaskRepository();
  TaskModel _currentTask;
  bool isTaskInProgress = false;
  List<TaskModel> _tasks = [];
  bool _isLoadTasks = true;

  get tasks => _tasks;

  get isLoadTasks => _isLoadTasks;

  get currentTask => _currentTask;

  init() {}

  Future<List<TaskModel>> loadTasks() {
    _isLoadTasks = true;
    Future.delayed(const Duration(milliseconds: 2500), () {
      _isLoadTasks = false;
      notifyListeners();
    });
  }

  Future<TaskModel> addNewTask(String title, String description,
      Priority priority, DateTime dueBy) async {
    isTaskInProgress = true;
    notifyListeners();

    TaskModel newTask =
        await _repository.addNewTask(title, description, priority, dueBy);
    _tasks.add(newTask);

    isTaskInProgress = false;
    notifyListeners();
    return newTask;
  }
}
