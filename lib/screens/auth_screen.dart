import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/screens/pp_screen.dart';
import '../widgets/auth_form.dart';
import 'forgot_password_screen.dart';
import '../provider/app_settings.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  var _isLoading = false;
  bool _isNewUser = false;
  final _timeNow = DateTime.now().toIso8601String();

  void _showSnackBar(BuildContext ctx, bool isSuccess,
      [String errMessage = '']) {
    Fluttertoast.showToast(
        msg: isSuccess ? 'Successfully Logged In!' : errMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    int phoneNo,
    BuildContext ctx,
  ) async {
    final _auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseFirestore.instance;
        await ref.collection('users').doc(authResult.user!.uid).set({
          'name': userName,
          'email': email,
          'mode': 'email',
          'phoneNo': phoneNo,
          'MOBY': 0,
          'imageUrl':
              "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg",
          'uid': authResult.user!.uid,
        });
        await FirebaseFirestore.instance
            .collection('mining')
            .doc(_auth.currentUser!.uid)
            .set({
          'isMining': false,
          'whenStarted': _timeNow,
          'whenEnded': _timeNow,
        });
      }
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      _isNewUser = authResult.additionalUserInfo!.isNewUser;
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your message!';
      if (err.message != null) {
        message = err.message.toString();
      }
      _showSnackBar(ctx, false, message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(
        context,
        false,
        err.toString().replaceRange(
              0,
              err.toString().indexOf(']') + 1,
              '',
            ),
      );
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final googleUser = await GoogleSignIn().signIn();

      await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleUser!.email);
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final _authData =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = FirebaseAuth.instance.currentUser;

      final ref = FirebaseFirestore.instance;
      if (_authData.additionalUserInfo!.isNewUser) {
        await ref.collection('users').doc(_authData.user!.uid).set({
          'email': _authData.user!.email,
          'name': _authData.user!.displayName,
          'mode': 'google',
          'phoneNo': -1,
          'MOBY': 0,
          'imageUrl': _authData.user?.photoURL ??
              "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg",
          'uid': _authData.user!.uid,
        });
        await FirebaseFirestore.instance
            .collection('mining')
            .doc(_authData.user!.uid)
            .set({
          'isMining': false,
          'whenStarted': _timeNow,
          'whenEnded': _timeNow,
        });
      }
      if (_authData != null) {
        _showSnackBar(ctx, true);
      }
      if (_authData.additionalUserInfo!.isNewUser) {
        Navigator.of(context).pushNamed(PPScreen.routeName);
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your message!';
      if (err.message != null) {
        message = err.message.toString();
      }
      _showSnackBar(ctx, false, message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final pColor = Theme.of(context).primaryColor;
    final appSettings = Provider.of<AppSettings>(context);
    appSettings.isNewUser = _isNewUser;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: AnimatedTextKit(
            displayFullTextOnTap: true,
            repeatForever: true,
            animatedTexts: [
              TyperAnimatedText(
                'Welcome to MobiByte!',
                speed: const Duration(milliseconds: 150),
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        shadowColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 5,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(''),
              background: Image.asset("assets/logo.png"),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 0.0,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text(
                              //   _isLogin ? 'Log in' : 'Sign Up',
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     fontSize: 50,
                              //     color: Theme.of(context).primaryColor,
                              //   ),
                              // ),
                              const SizedBox(
                                height: 20,
                              ),
                              AuthForm(
                                _isLogin,
                                _handleGoogleSignIn,
                                _submitAuthForm,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    AnimatedContainer(
                                      height: _isLogin ? 50 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              ForgotPasswordScreen.routeName);
                                        },
                                        child: const Text('Forgot password?'),
                                        style: TextButton.styleFrom(
                                            alignment: Alignment.center),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(_isLogin
                                        ? 'Don\'t have an account?'
                                        : 'Already have an account?'),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                        });
                                      },
                                      child: Text(_isLogin
                                          ? 'Create New Account'
                                          : 'Log in instead'),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}
