import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';

import 'package:provider/provider.dart';
import 'package:todo_list_for_doit_software/global/constant.dart';
import 'package:todo_list_for_doit_software/global/translator.dart';

import 'package:todo_list_for_doit_software/provider/task_provider.dart';

class DetailTaskScreen extends StatefulWidget {
  @override
  _DetailTaskScreenState createState() => _DetailTaskScreenState();
}

class _DetailTaskScreenState extends State<DetailTaskScreen> {
  String title = '';
  bool isCreateNewTask = false;
  bool isEditMode = false;
  Priority currentPriority = Priority.MEDIUM;
  DateTime currentDueBy = DateTime.now();

  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.isTaskInProgress = false;
    if (taskProvider.currentTask == null) {
      isCreateNewTask = true;
      isEditMode = true;
    } else {
      currentPriority = taskProvider.currentTask.priority;
      currentDueBy = taskProvider.currentTask.dueBy;
      _title.text = taskProvider.currentTask.title;
      isCreateNewTask = false;
      isEditMode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initializeTitle(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                isEditMode = true;
                setState(() {});
              },
            )
          ],
          leading: InkWell(
              onTap: () {
                final taskProvider =
                    Provider.of<TaskProvider>(context, listen: false);
                taskProvider.remuveCurrentTask();

                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
        ),
        body: Stack(
          children: <Widget>[
            Container(margin: EdgeInsets.all(12.0), child: _buildBody(context)),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildButtons(context),
            )
          ],
        ));
  }

  initializeTitle(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    if (title.isEmpty) {
      if (taskProvider.currentTask == null) {
        title = Translator.of(context).text('create_new_task');
      } else {
        title = Translator.of(context).text('view_task');
      }
    }
  }

  Widget _buildBody(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(Translator.of(context).text('title_label')),
        TextFormField(
//          initialValue:isCreateNewTask? taskProvider.currentTask.title:" " ,
          controller: _title,
          enabled: isEditMode,
          validator: (value) => (value.isEmpty)
              ? Translator.of(context).text('alert_title_required')
              : null,
        ),
        Container(
          margin: EdgeInsets.all(20.0),
          child: DateTimeFormField(
            label: "Date Time",
            validator: (DateTime dateTime) {
              if (dateTime == null) {
                return "Date Time Required";
              }
              return null;
            },

              onSaved: (DateTime dateTime) => currentDueBy = dateTime,
          ),
        ),
        _buildPriority(context),
        _buildChoicePriority(context),
      ],
    );
  }

  Widget _buildPriority(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(Translator.of(context).text('priority_label')),
        isEditMode ? Container() : Text('Priority')
      ],
    );
  }

  Widget _buildChoicePriority(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        OutlineButton(
          onPressed: () {
            if (isEditMode) setCurrentPriority(context, Priority.LOW);
          },
          hoverColor: Colors.orange,
          shape: StadiumBorder(),
          borderSide: BorderSide(
              width: 2,
              color:
                  currentPriority == Priority.LOW ? Colors.green : Colors.grey),
          child: Text(Translator.of(context).text('priority_low')),
        ),
        OutlineButton(
          onPressed: () {
            if (isEditMode) setCurrentPriority(context, Priority.MEDIUM);
          },
          shape: StadiumBorder(),
          borderSide: BorderSide(
              width: 2,
              color: currentPriority == Priority.MEDIUM
                  ? Colors.green
                  : Colors.grey),
          child: Text(Translator.of(context).text('priority_medium')),
        ),
        OutlineButton(
          onPressed: () {
            if (isEditMode) setCurrentPriority(context, Priority.HIGH);
          },
          shape: StadiumBorder(),
          borderSide: BorderSide(
              width: 2,
              color: currentPriority == Priority.HIGH
                  ? Colors.green
                  : Colors.grey),
          child: Text(Translator.of(context).text('priority_high')),
        ),
      ],
    );
  }

  void setCurrentPriority(BuildContext context, Priority priority) {
    setState(() {
      currentPriority = priority;
    });
  }

  Widget _buildButtons(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    if (taskProvider.isTaskInProgress) {
      return CircularProgressIndicator();
    }

    if (isCreateNewTask) {
      return FlatButton(
        onPressed: () async {
          if (_title.text.isNotEmpty) {
            await taskProvider.addNewTask(
                _title.text, _description.text, currentPriority, currentDueBy);

            isCreateNewTask = false;
            isEditMode = false;
            updateTitle(context);
          }
        },
        child: Text(Translator.of(context).text('create_task')),
      );
    } else {
      if (isEditMode) {
        return Row(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                isEditMode = false;
                updateTitle(context);
              },
              child: Text(Translator.of(context).text('cancel')),
            ),
            FlatButton(
              onPressed: () async {
                await taskProvider.updateTask(
                    _title.text, currentPriority, currentDueBy);
                isEditMode = false;
                updateTitle(context);
              },
              child: Text(Translator.of(context).text('save_task')),
            )
          ],
        );
      } else {
        return FlatButton(
          onPressed: () async {
            await taskProvider.deleteTask(taskProvider.currentTask.id);
            Navigator.pop(context);
          },
          child: Text(Translator.of(context).text('delete_task')),
        );
      }
    }
  }

  updateTitle(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    if (taskProvider.currentTask == null) {
      title = Translator.of(context).text('create_new_task');
    } else {
      if (isEditMode) {
        title = Translator.of(context).text('view_task');
      } else {
        title = Translator.of(context).text('edit_task');
      }
      title = Translator.of(context).text('view_task');
    }
    setState(() {});
  }
}
