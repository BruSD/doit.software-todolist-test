import 'package:todo_list_for_doit_software/global/constant.dart';

class TaskModel {
  int id;
  String title;
  DateTime dueBy;
  Priority priority;
  String description;

  TaskModel({this.title, this.dueBy, this.priority, this.description});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': this.title,
        'priority': getPriorityFromEnum(),
        'dueBy': toUnix(),
      };

  TaskModel videoFromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String,
      description: json['description'] as String,
      priority: getEnumFromPriority(json['priority'] as String),
      dueBy: DateTime.parse(json['dueBy'] as String),
    );
  }

  int toUnix() {
    return (this.dueBy.millisecondsSinceEpoch / 1000).round();
  }

  String getPriorityFromEnum() {
    switch (priority) {
      case Priority.LOW:
        return 'Low';
      case Priority.MEDIUM:
        return 'Normal';
      case Priority.HIGH:
        return 'High';
        break;
    }
  }

  Priority getEnumFromPriority(String string) {
    switch (string) {
      case 'Low':
        return Priority.LOW;
      case 'Normal':
        return Priority.MEDIUM;
      case 'High':
        return Priority.HIGH;
    }
  }
}
