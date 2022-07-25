import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../provider/app_settings.dart';
import 'loading_screen.dart';

class PPScreen extends StatefulWidget {
  static const routeName = '/pp';
  @override
  State<PPScreen> createState() => _PPScreenState();
}

class _PPScreenState extends State<PPScreen> {
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String imageUrl = "";
  @override
  void didChangeDependencies() {
    _loadImage();
    super.didChangeDependencies();
  }

  final userid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _loadImage() async {
    final _userData =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    final _imageUrl = _userData.data()?['imageUrl'];
    setState(() {
      imageUrl = _imageUrl;
    });
  }

  XFile _storedImage = XFile('');
  Future<void> _takePicture(bool isCamera, BuildContext ctx) async {
    final appSettings = Provider.of<AppSettings>(ctx, listen: false);
    final uid = appSettings.getAuthInfo.currentUser!.uid;
    final _imageFile = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 600,
    );

    if (_imageFile == null) {
      return;
    }
    _storedImage = _imageFile;
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final savedImage = await _imageFile.saveTo('${appDir.path}/$uid');
    try {
      final task = firebase_storage.FirebaseStorage.instance
          .ref('dp/$uid')
          .putFile(File(_imageFile.path));
      try {
        // Storage tasks function as a Delegating Future so we can await them.
        Navigator.of(context).pushNamed(LoadingScreen.routeName);
        firebase_storage.TaskSnapshot snapshot = await task;
        Navigator.of(context).pop();
        print('Uploaded ${snapshot.bytesTransferred} bytes.');
        String _downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref('dp/$uid')
            .getDownloadURL();
        appSettings.updatePhotoUrl(_downloadURL);
      } on firebase_storage.FirebaseException catch (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        print(task.snapshot);

        if (e.code == 'permission-denied') {
          showToast(
              'User does not have permission to upload to this reference.');
        }
        // ...
      }

      showToast("Profile Picture updated successfully");
    } on firebase_storage.FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close))
        ],
        title: const FittedBox(
          child: Text("Change your Profile Picture"),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userid)
                  .get(),
              builder: (ctx,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      userData) {
                if (userData.hasData) {
                  final _imageUrl = userData.data!['imageUrl'];
                  imageUrl = _imageUrl;
                  return CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 4,
                    backgroundImage: NetworkImage(imageUrl),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 80,
            ),
            TextButton.icon(
              onPressed: () async {
                await _takePicture(false, context);
                _loadImage();
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Select From Gallery'),
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20.0),
                  backgroundColor: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
              icon: const Icon(Icons.add_a_photo),
              onPressed: () async {
                await _takePicture(true, context);
                _loadImage();
              },
              label: const Text('Click from Camera'),
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20.0),
                  backgroundColor: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
