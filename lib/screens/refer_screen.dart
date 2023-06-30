import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../provider/app_settings.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({Key? key}) : super(key: key);

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  void doSetState() {
    setState(() {});
  }

  bool _isLoading = false;
  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print("build called");
    final _appSettings = Provider.of<AppSettings>(context);

    var _name = "";
    var _email = "";
    void _saveForm() {
      _fKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (_fKey.currentState != null && _fKey.currentState!.validate()) {
        _fKey.currentState!.save();
      }
    }

    void _infoInput(bool toRefer) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter Details of user"),
          content: Text(toRefer
              ? "from whom you want to get referred"
              : "you want to refer"),
          actions: [
            StatefulBuilder(
              builder: (ctx, setState) => Form(
                key: _fKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        key: const ValueKey('username'),
                        validator: (val) {
                          if (val != "") {
                            return null;
                          }
                          return "Name cannot be empty";
                        },
                        onChanged: (val) {
                          _name = val;
                        },
                        onSaved: (val) {
                          _name = val.toString();
                        },
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: true,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Theme.of(context).indicatorColor,
                          ),

                          label: const Text('Name'),
                          hintText: 'Enter the Name',
                          // helperText: 'What do we call you?',
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Theme.of(context).indicatorColor,
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(
                          //       color: Colors.grey,
                          //       width: 2.0,
                          //       style: BorderStyle.solid),
                          //   borderRadius: BorderRadius.circular(15),
                          // ),
                          // focusedBorder: const OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: Colors.grey,
                          //       width: 2.0,
                          //       style: BorderStyle.solid),
                          // ),
                        ),
                      ),
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value.toString())) {
                            return null;
                          }
                          return 'Invalid email entered, please check again!';
                        },
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        onChanged: (val) {
                          _email = val;
                        },
                        onSaved: (val) {
                          _email = val.toString();
                        },
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          label: const Text('E-mail'),
                          hintText: 'Enter the E-mail',
                          labelStyle: TextStyle(
                            color: Theme.of(context).indicatorColor,
                          ),
                          // helperText: 'Please enter a valid Google email id',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).indicatorColor,
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(
                          //       color: Colors.grey,
                          //       width: 2.0,
                          //       style: BorderStyle.solid),
                          //   borderRadius: BorderRadius.circular(15),
                          // ),
                          // focusedBorder: const OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: Colors.grey,
                          //       width: 2.0,
                          //       style: BorderStyle.solid),
                          // ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              child: Text("Done"),
                              onPressed: () async {
                                if (!toRefer) {
                                  Navigator.of(context).pop();
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                final result = await _appSettings.getReferred(
                                    _name, _email);
                                Fluttertoast.showToast(
                                    msg: !result
                                        ? 'Please check entered information'
                                        : "You have been rewarded with 20 MOBIBYTES",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                setState(() {
                                  _isLoading = false;
                                });
                                if (result) {
                                  Navigator.of(context).pop();
                                }
                                doSetState();
                              })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return FutureBuilder(
        future: _appSettings.getUserdataMap,
        builder: (ctx, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final _isReferred = snapshot.data!['referredBy'] != null;
          final _referrerID = snapshot.data!['referredBy'];
          print("isReferred");
          // print(snapshot.data);
          // print(_referrerID);
          return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const FittedBox(
                      child: Text(
                        "Earn MOBY with your family and friends!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        "Each referral with fetch both parties 20 MobiBytes!"),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      "You have been referred by:",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: _isReferred
                          ? FutureBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              future: _appSettings.dbInstance
                                  .collection('users')
                                  .doc(_referrerID)
                                  .get(),
                              builder: (ctx, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                print("isReferred");
                                final referrerDetails = snap.data!.data();

                                if (referrerDetails != null) {
                                  print(referrerDetails);
                                } else {
                                  print("bt");
                                }
                                if (referrerDetails == null) {
                                  return Text("error!");
                                }
                                final referrerName = referrerDetails["name"];
                                final referrerEmail = referrerDetails["email"];
                                final referrerImageUrl = referrerDetails[
                                        'imageUrl'] ??
                                    "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";

                                print(
                                    "$referrerName , $referrerEmail , $referrerImageUrl");
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      referrerImageUrl,
                                    ),
                                  ),
                                  title: Text(referrerName),
                                  subtitle: Text(referrerEmail),
                                );
                              })
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //             ListTile(
                                //   leading: CircleAvatar(
                                //     backgroundImage: NetworkImage(photoUrl),
                                //   ),
                                //   title: Text(
                                //     displayName,
                                //   ),
                                //   subtitle: FittedBox(
                                //     child: Text(
                                //       _auth.currentUser!.email.toString(),
                                //     ),
                                //   ),
                                // ),
                                Text("No one!"),
                                if (!_isReferred)
                                  ElevatedButton(
                                    onPressed: () {
                                      _infoInput(true);
                                    },
                                    child: const Text("Get referred"),
                                  ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      "You have referred:",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("No one!"),
                            ElevatedButton(
                              onPressed: () {
                                _infoInput(false);
                              },
                              child: const Text("Refer someone"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
