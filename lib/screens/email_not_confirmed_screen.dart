import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../provider/app_settings.dart';

class EmailNotConfirmedScreen extends StatelessWidget {
  Function refresher;
  EmailNotConfirmedScreen(this.refresher);

  static const routeName = '/email-not-confirmed';

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            IconButton(
                onPressed: () async {
                  await appSettings.signOutConfirmation(context);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
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
                'An email has been sent to you,\n please confirm your email to proceed further.',
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    refresher();
                    Fluttertoast.showToast(
                        msg: 'Refreshing...',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'))
            ],
          ),
        ));
  }
}
