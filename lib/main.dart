import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_for_doit_software/provider/a_provider_setup.dart';
import 'package:todo_list_for_doit_software/provider/user_provider.dart';
import 'package:todo_list_for_doit_software/ui/dashboard_screen.dart';
import 'package:todo_list_for_doit_software/ui/sing_screen.dart';

import 'global/translator.dart';

Future main() {
  runApp(MultiProvider(
      providers: ProviderSetup.kProviders,
      child: MaterialApp(
//        initialRoute: Routes.root,
//        routes: Routes.maps,
        color: Colors.white,
        debugShowCheckedModeBanner: true,
        localizationsDelegates: Translator.supportedDelegates,
        supportedLocales: Translator.supportedLocales,
        localeResolutionCallback: Translator.resolutionCallback,
        home: MyApp(),
      )));
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Consumer<UserProvider>(
            builder: (context, auth, _) => Scaffold(
                  body: auth.isAuthenticated
                      ? DashboardScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: Container(
                                          color: Colors.white,
                                          child: CircularProgressIndicator()))
                                  : auth.isAuthenticated
                                      ? DashboardScreen()
                                      : SignScreen(),
                        ),
                )),
      ),
    );
  }
}
