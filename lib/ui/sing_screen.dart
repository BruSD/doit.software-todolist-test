import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_for_doit_software/global/translator.dart';
import 'package:todo_list_for_doit_software/provider/user_provider.dart';
import 'package:todo_list_for_doit_software/ui/dashboard_screen.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  TextEditingController _login = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _passwordRepeat = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  GlobalKey _scaffold = GlobalKey();

  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        key: _scaffold,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLoginWithEmail(context),

//                  _buildSignUpWithEmail(context, userAuthProvider),
              ]),
        ));
  }

  Widget _buildLoginWithEmail(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Size _deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _login,
              validator: (value) => (value.isEmpty)
                  ? Translator.of(context).text('alert_email')
                  : null,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: Translator.of(context).text('user_name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _password,
              obscureText: true,
              validator: (value) => (value.isEmpty)
                  ? Translator.of(context).text('alert_password')
                  : null,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: Translator.of(context).text('password'),
              ),
            ),
          ),
          !isSignUp
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _passwordRepeat,
                    obscureText: true,
                    validator: (value) => (value.isEmpty)
                        ? Translator.of(context).text('alert_password')
                        : null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: Translator.of(context).text('repeat_password'),
                    ),
                  ),
                ),
          Container(
            alignment: Alignment.bottomRight,
            child: Switch(
              value: isSignUp,
              onChanged: (value) {
                setState(() {
                  isSignUp = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: userProvider.loading == true
                ? CircularProgressIndicator()
                : Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).accentColor,
                    child: MaterialButton(
                      minWidth: _deviceSize.width,
                      onPressed: () {
                        if (isSignUp) {
                          _signUp(context);
                        } else {
                          _signIn(context);
                        }
                      },
                      child: Text(
                        isSignUp
                            ? Translator.of(context).text('sign_up')
                            : Translator.of(context).text('sign_in'),
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _signIn(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context);
    if (_formKey.currentState.validate()) {
      userProvider.loading = true;
      if (!await userProvider.signIn(_login.text, _password.text)) {
        final snackBar = SnackBar(
          content: Text('Uuups : ' + userProvider.authError()),
        );
        debugPrint(userProvider.authError());
        Scaffold.of(_scaffold.currentContext).showSnackBar(snackBar);
      } else {
        _lunchDashboard();
      }
    }
  }

  _signUp(BuildContext context) async {
    if (isPaswordsValid(context)) {
      final userProvider = Provider.of<UserProvider>(context);
      if (_formKey.currentState.validate()) {
        userProvider.loading = true;
        if (!await userProvider.signUp(_login.text, _password.text)) {
          final snackBar = SnackBar(
            content: Text('Uuups : ' + userProvider.authError()),
          );
          debugPrint(userProvider.authError());
          Scaffold.of(_scaffold.currentContext).showSnackBar(snackBar);
        } else {
          _lunchDashboard();
        }
      }
    } else {
      final snackBar = SnackBar(
        content: Text(Translator.of(context).text('upss_passwords')),
      );
      Scaffold.of(_scaffold.currentContext).showSnackBar(snackBar);
    }
  }

  _lunchDashboard() {
    Navigator.push(
      _scaffold.currentContext,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(),
      ),
    );
  }

  bool isPaswordsValid(BuildContext context) {
    if (_password.text == _passwordRepeat.text) {
      return true;
    }
    return false;
  }
}
