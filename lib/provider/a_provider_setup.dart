import 'package:provider/provider.dart';
import 'package:todo_list_for_doit_software/provider/task_provider.dart';
import 'package:todo_list_for_doit_software/provider/user_provider.dart';

class ProviderSetup {
  static List<SingleChildCloneableWidget> kProviders = [
    ...kDependentServices,
  ];

  static List<SingleChildCloneableWidget> kDependentServices = [
    ChangeNotifierProvider(builder: (_) => UserProvider()),
    ChangeNotifierProvider(builder: (_) => TaskProvider()),
  ];
}
