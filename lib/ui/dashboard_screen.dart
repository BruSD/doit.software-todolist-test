import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_for_doit_software/global/translator.dart';
import 'package:todo_list_for_doit_software/provider/user_provider.dart';

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
            onTap: () {
              Provider.of<UserProvider>(context).logOut();
            },
            child: Icon(Icons.cancel),
          )
        ],
      ),
      body: Center(
        child: Text('Place for task'),
      ),
    );
  }
}
