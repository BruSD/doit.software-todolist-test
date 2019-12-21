import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_for_doit_software/global/translator.dart';
import 'package:todo_list_for_doit_software/provider/task_provider.dart';
import 'package:todo_list_for_doit_software/provider/user_provider.dart';
import 'package:todo_list_for_doit_software/ui/detaile_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(Translator.of(context).appName()),
        actions: <Widget>[
          InkWell(
            onTap: () {},
            child: Icon(Icons.sort),
          ),
          InkWell(
            onTap: () {
              Provider.of<UserProvider>(context).logOut();
            },
            child: Icon(Icons.cancel),
          )
        ],
      ),
      body: _buildMain(context),
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

  Widget _buildMain(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    if (taskProvider.isLoadTasks) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text('Her will be list');
    }
  }
}
