import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:todo_list_for_doit_software/global/translator.dart';
import 'package:todo_list_for_doit_software/model/task_model.dart';
import 'package:todo_list_for_doit_software/provider/task_provider.dart';
import 'package:todo_list_for_doit_software/provider/user_provider.dart';
import 'package:todo_list_for_doit_software/ui/detaile_task_screen.dart';

class Constants {
  static const String FirstItem = 'Sort by Name';
  static const String SecondItem = 'Sort by Priority';
  static const String ThirdItem = 'Sort by Date';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
  ];
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).init();
  }

  void choiceAction(String choice, BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    if (choice == Constants.FirstItem) {
      taskProvider.sortByName();
    } else if (choice == Constants.SecondItem) {
      taskProvider.sortByPririty();
    } else if (choice == Constants.ThirdItem) {
      taskProvider.sortByDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Translator.of(context).appName()),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (choice) {
              choiceAction(choice, context);
            },
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: () {
            _onRefresh(context);
          },
          header: WaterDropHeader(),
          child: _buildMain(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTaskScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Toggle',
      ),
    );
  }

  void _onRefresh(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context);
    await taskProvider.loadTasks();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  Widget _buildMain(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    if (taskProvider.isLoadTasks) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return taskProvider.tasks.length == 0
          ? Center(
        child: Text(Translator.of(context).text('now_tasks_for_now')),
      )
          : _buildListOfTask(context);
    }
  }

  Widget _buildListOfTask(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, position) {
        return _buildListItem(context, position);
      },
    );
  }

  Widget _buildListItem(BuildContext context, int position) {
    final taskProvider = Provider.of<TaskProvider>(context);
    TaskModel taskModel = taskProvider.tasks[position];
    String formattedDate = DateFormat('MMM-dd – kk:mm').format(taskModel.dueBy);

    return Card(
      child: InkWell(
        onTap: () {
          taskProvider.selectTaskToView(position);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTaskScreen(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          taskModel.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              formattedDate,
                            ),
                            FlatButton.icon(
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: taskModel.getColor(),
                                ),
                                label: Text(taskModel.getPriorityFromEnum()))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
