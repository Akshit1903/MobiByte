import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Mine with ChangeNotifier {
  var _page = 2;

  int get page {
    return _page;
  }

  void setPageNo(int pageNo) {
    _page = pageNo;
    notifyListeners();
  }

  var _isMining = false;

  final _firestoreDb = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;
  double _moby = 0.0;
  FirebaseAuth get authIns {
    return _auth;
  }

  double get moby {
    return _moby;
  }

  bool get isMining {
    return _isMining;
  }

  Future<void> refreshCoins() async {
    final _uid = _auth.currentUser!.uid;
    final _mineData = await _firestoreDb.collection('mining').doc(_uid).get();
    final _userData = await _firestoreDb.collection('users').doc(_uid).get();
    final _whenStarted = DateTime.parse(_mineData['whenStarted']);
    final _whenEnded = DateTime.parse(_mineData['whenEnded']);

    if (_isMining) {
      await _firestoreDb.collection('mining').doc(_auth.currentUser!.uid).set({
        'isMining': _isMining,
        'whenStarted': DateTime.now().toIso8601String(),
        'whenEnded': _whenEnded.toIso8601String(),
      });
    } else {
      await _firestoreDb.collection('mining').doc(_auth.currentUser!.uid).set({
        'isMining': _isMining,
        'whenStarted': _whenStarted.toIso8601String(),
        'whenEnded': DateTime.now().toIso8601String(),
      });
    }

    // print(_userData.data() != null ? _userData!.data()['MOBY'] : 0);
    if (_whenEnded == _whenStarted) {
      _moby = double.parse(_userData['MOBY'].toStringAsFixed(6));
    } else {
      if (_whenStarted.isBefore(_whenEnded)) {
        _moby = double.parse(_userData['MOBY'].toStringAsFixed(6));
      } else {
        var extra = double.parse(
                DateTime.now().difference(_whenStarted).inSeconds.toString()) *
            0.0001;
        _moby = double.parse((_userData['MOBY'] + extra).toStringAsFixed(6));

        final uData = _userData.data() ?? {};
        await _firestoreDb.collection('users').doc(_uid).set({
          'name': uData['name'],
          'email': uData['email'],
          'mode': uData['mode'],
          'phoneNo': uData['phoneNo'],
          'MOBY': _moby,
          'imageUrl': uData['imageUrl']
        });
      }
    }

    notifyListeners();
  }

  void toggleMining() async {
    _isMining = !_isMining;
    final _uid = _auth.currentUser!.uid;
    final _userData = await _firestoreDb.collection('users').doc(_uid).get();
    final _mineData = await _firestoreDb.collection('mining').doc(_uid).get();
    final _whenStarted = DateTime.parse(_mineData['whenStarted']);
    final _whenEnded = DateTime.parse(_mineData['whenEnded']);

    if (_isMining) {
      await _firestoreDb.collection('mining').doc(_auth.currentUser!.uid).set({
        'isMining': _isMining,
        'whenStarted': DateTime.now().toIso8601String(),
        'whenEnded': _whenEnded.toIso8601String(),
      });
    } else {
      await _firestoreDb.collection('mining').doc(_auth.currentUser!.uid).set({
        'isMining': _isMining,
        'whenStarted': _whenStarted.toIso8601String(),
        'whenEnded': DateTime.now().toIso8601String(),
      });
    }
    notifyListeners();
  }
}
