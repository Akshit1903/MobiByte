import 'package:flutter/material.dart';

class ForgotPasswordScreen2 extends StatelessWidget {
  const ForgotPasswordScreen2({Key? key}) : super(key: key);
  static const routeName = '\forgot-password-2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Please check your inbox',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                Icons.email_outlined,
                color: Theme.of(context).indicatorColor,
                size: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'An email has been sent to you,\n please refer it for further instructions',
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}
