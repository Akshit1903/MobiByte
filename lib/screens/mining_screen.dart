import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/mine.dart';

class MiningScreen extends StatefulWidget {
  const MiningScreen({Key? key}) : super(key: key);

  @override
  State<MiningScreen> createState() => _MiningScreenState();
}

class _MiningScreenState extends State<MiningScreen> {
  @override
  Widget build(BuildContext context) {
    final mineData = Provider.of<Mine>(context);
    var _isMining = mineData.isMining;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Now you can mine cryptocurrency at the convinence of your phone!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'One click instant mining!',
            style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                mineData.toggleMining();
              });
            },
            child: Text(
              _isMining ? 'Stop Mining' : 'Start Mining',
              style: const TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              primary: !_isMining
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).errorColor,
              onPrimary: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
