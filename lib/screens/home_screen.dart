import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mobibyte/widgets/home.dart';
import 'package:provider/provider.dart';

import '../provider/app_settings.dart';

import 'email_not_confirmed_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void didChangeDependencies() {
  //   final appSettings = Provider.of<AppSettings>(context);
  //   displayName = appSettings.getDisplayName;
  //   super.didChangeDependencies();
  // }

  var _isLoading = false;

  void _callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return !FirebaseAuth.instance.currentUser!.emailVerified
        ? EmailNotConfirmedScreen(_callSetState)
        : FutureBuilder(
            future: Provider.of<AppSettings>(context).getUserdataMap,
            builder: (ctx, AsyncSnapshot<Map<String, dynamic>> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // if (photoUrl ==
              //     "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg") {
              //   Navigator.of(context).pushNamed(PPScreen.routeName);
              // }
              return Home(snapShot);
            });
  }
}
