import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../provider/app_settings.dart';
import 'forgot_password_screen2.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '\forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String userEmail = "";
  final _emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    void _saveForm() {
      _emailKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (_emailKey.currentState != null &&
          _emailKey.currentState!.validate()) {
        _emailKey.currentState!.save();
      }
      if (userEmail != "") {
        appSettings.passwordReset(userEmail);
        Navigator.of(context)
            .pushReplacementNamed(ForgotPasswordScreen2.routeName);
      } else {
        Fluttertoast.showToast(
            msg: 'An error occured, please check your e-mail',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Form(
        key: _emailKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Your Email',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Theme.of(context).indicatorColor,
                  ),
                  labelStyle:
                      TextStyle(color: Theme.of(context).indicatorColor),
                  hintText: 'Enter your E-mail',
                ),
                validator: (value) {
                  if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value.toString())) {
                    return null;
                  }
                  print('validator valid');
                  return 'Invalid email entered, please check again!';
                },
                onSaved: (val) {
                  userEmail = val.toString();
                  print(1);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Send Email'),
                onPressed: () {
                  _saveForm();
                  print(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
