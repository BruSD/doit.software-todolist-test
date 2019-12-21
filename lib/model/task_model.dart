import 'package:flutter/cupertino.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';

class TaskModel {
  int id;
  String title;
  DateTime dueBy;
  Priority priority;
  String description;

  TaskModel({this.id, this.title, this.dueBy, this.priority, this.description});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': this.title,
        'priority': getPriorityFromEnum(),
        'dueBy': toUnix(),
      };

  TaskModel taskFromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      priority: getEnumFromPriority(json['priority'] as String),
      dueBy:
          DateTime.fromMillisecondsSinceEpoch(fromUnix(json['dueBy'] as int)),
    );
  }

  int toUnix() {
    return (this.dueBy.millisecondsSinceEpoch / 1000).round();
  }

  int fromUnix(int unixTime) {
    debugPrint(unixTime.toString());
    return unixTime * 1000;
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
