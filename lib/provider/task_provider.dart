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

  init() {
    loadTasks();
  }

  Future<List<TaskModel>> loadTasks() async {
    _isLoadTasks = true;
    _tasks = await _repository.getAllTasks();

    _isLoadTasks = false;
    notifyListeners();
  }

  Future<TaskModel> addNewTask(String title, String description,
      Priority priority, DateTime dueBy) async {
    isTaskInProgress = true;
    notifyListeners();

    TaskModel newTask =
        await _repository.addNewTask(title, description, priority, dueBy);
    _tasks.add(newTask);
    _currentTask = newTask;
    isTaskInProgress = false;
    notifyListeners();
    return newTask;
  }

  Future<TaskModel> updateTask(
      String title, Priority priority, DateTime dueBy) async {
    isTaskInProgress = true;
    notifyListeners();
    _currentTask.title = title;
    _currentTask.priority = priority;
    _currentTask.dueBy = dueBy;

    await _repository.updateTask(_currentTask);
    isTaskInProgress = false;
  }

  Future<TaskModel> deleteTask(int id) async {
    isTaskInProgress = true;
    notifyListeners();

    remuveCurrentTask();
    await _repository.deleteTask(id);
    deleteFromList(id);
    isTaskInProgress = false;
  }

  deleteFromList(int id) {
    _tasks = _tasks.where((task) => task.id != id).toList();
  }

  void selectTaskToView(index) {
    _currentTask = _tasks[index];
  }

  void remuveCurrentTask() {
    _currentTask = null;
  }
}
