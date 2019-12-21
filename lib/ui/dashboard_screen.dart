import 'package:flutter/material.dart';
import 'package:todo_list_for_doit_software/global/translator.dart';

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
      ),
      body: Center(child: Text('Place for task'),),
    );
  }
}
