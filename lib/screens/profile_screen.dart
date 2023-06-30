import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/mine.dart';
import './home_screen.dart';
import '../provider/app_settings.dart';
import './pp_screen.dart';
import '../provider/app_settings.dart';
import '../widgets/moby_display.dart';

class ProfileScreen extends StatefulWidget {
  final void Function(int) setPageValue;
  ProfileScreen(this.setPageValue);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String displayName = "";
  @override
  void didChangeDependencies() {
    final appSettings = Provider.of<AppSettings>(context);
    displayName = appSettings.getDisplayName;
    super.didChangeDependencies();
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final mineData = Provider.of<Mine>(context);

    final _accountCreated = DateFormat.yMMMMd()
        .add_jm()
        .format(_auth.currentUser!.metadata.creationTime ?? DateTime.now());
    final _lastLoginDate = DateFormat.yMMMMd()
        .add_jm()
        .format(_auth.currentUser!.metadata.lastSignInTime ?? DateTime.now());

    return FutureBuilder(
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
          displayName = snapShot.data!['name'];

          final photoUrl = snapShot.data != null
              ? snapShot.data!['imageUrl']
              : "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg";

          return RefreshIndicator(
            onRefresh: mineData.refreshCoins,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(PPScreen.routeName);
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 5,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _auth.currentUser!.email.toString(),
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Account created on: $_accountCreated',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Last login: $_lastLoginDate',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  MobyDisplay(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        mineData.setPageNo(1);
                      });
                    },
                    child: const Text('Refer your friends and earn MOBY*'),
                  )
                ],
              ),
            ),
          );
        });
  }
}
