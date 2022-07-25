// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppSettings with ChangeNotifier {
  final _ref = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool isNewUser = false;

  FirebaseAuth get getAuthInfo {
    return _auth;
  }

  Future<void> signOutConfirmation(BuildContext c) async {
    showDialog(
        context: c,
        builder: (ctx) => AlertDialog(
              title: const Text('Sign out?'),
              content: const Text(
                'Do you want to sign out?',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(c).pop();
                    },
                    child: Text('No')),
                TextButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(c).pop();
                    },
                    child: Text('Yes')),
              ],
            ));
  }

  Future<String> _getDisplayName() async {
    final _userData =
        await _ref.collection('users').doc(_auth.currentUser!.uid).get();
    final _userDataMap = _userData.data();
    print(_userDataMap);
    var _displayName = _userDataMap?['name'];
    if (_displayName != null) {
      print(_displayName);
      return _displayName;
    }
    _displayName = _auth.currentUser!.displayName.toString();
    print(_displayName);
    if (_displayName != null) {
      return _displayName;
    }
    return "";
  }

  String displayName = "";
  void _setDisplayName() async {
    displayName = await _getDisplayName();
  }

  String get getDisplayName {
    _setDisplayName();
    return displayName;
  }

  FirebaseFirestore get dbInstance {
    return FirebaseFirestore.instance;
  }

  FirebaseAuth get authInstance {
    return _auth;
  }

  Future<void> passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Fluttertoast.showToast(
          msg: '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<Map<String, dynamic>> get getUserdataMap async {
    final _userData =
        await _ref.collection('users').doc(_auth.currentUser!.uid).get();
    final _userDataMap = _userData.data();
    if (_userDataMap == null) {
      return {};
    }
    return _userDataMap;
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    final _userDataMap = await getUserdataMap;
    await _ref.collection('users').doc(_auth.currentUser!.uid).set({
      'name': _userDataMap['name'],
      'email': _userDataMap['email'],
      'mode': _userDataMap['mode'],
      'phoneNo': _userDataMap['phoneNo'],
      'MOBY': _userDataMap['MOBY'],
      'imageUrl': photoUrl,
    });
  }

  Future<bool> getReferred(String name, String email) async {
    final temp =
        await _ref.collection('users').where("email", isEqualTo: email).get();
    print(temp.docs[0].data());
    temp.docs.forEach((element) {
      print(element.data());
    });
    final userData = await getUserdataMap;

    if (!temp.docs[0].data()['name'].toString().contains(name)) {
      return false;
    }
    print(double.parse(userData['MOBY'].toString()));
    await _ref.collection('users').doc(_auth.currentUser!.uid).set({
      'mode': userData['mode'],
      'imageUrl': userData['imageUrl'],
      'name': userData['name'],
      'MOBY': double.parse(userData['MOBY'].toString()) + 20,
      'email': userData['email'],
      'phoneNo': userData['phoneNo'],
      'uid': userData['uid'],
      'referredBy': temp.docs[0].data()['uid'],
    });
    return true;
  }
}
