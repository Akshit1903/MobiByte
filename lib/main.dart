import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobibyte/provider/app_settings.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import '../provider/mine.dart';
import 'screens/pp_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/forgot_password_screen2.dart';
import 'screens/email_not_confirmed_screen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _callSetState() {}
    return MultiProvider(
      providers: [
        Provider<Mine>(
          create: (_) => Mine(),
        ),
        Provider<AppSettings>(
          create: (_) => AppSettings(),
        ),
      ],
      child: MaterialApp(
        title: 'MobiByte',
        theme: ThemeData(
          backgroundColor: const Color.fromRGBO(240, 226, 175, 1),
          primarySwatch: Colors.teal,
          indicatorColor: Colors.teal,
          fontFamily: 'Montserrat',
          primaryTextTheme: const TextTheme(
              bodyText1:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        darkTheme: ThemeData(
          cardColor: const Color.fromRGBO(10, 18, 54, 1),
          backgroundColor: const Color.fromRGBO(15, 29, 80, 1),
          primarySwatch: Colors.amber,
          primaryColor: Colors.black45,
          primaryTextTheme: const TextTheme(
              bodyText1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            subtitle1: TextStyle(
              color: Colors.white,
            ),
          ),
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Colors.black,
          brightness: Brightness.dark,
          primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          appBarTheme: const AppBarTheme(brightness: Brightness.dark),
          iconTheme: const IconThemeData(
            color: Colors.amber,
            opacity: 1,
          ),
        ),
        themeMode: ThemeMode.system,
        routes: {
          PPScreen.routeName: (ctx) => PPScreen(),
          LoadingScreen.routeName: (ctx) => LoadingScreen(),
          ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
          ForgotPasswordScreen2.routeName: (ctx) =>
              const ForgotPasswordScreen2(),
          EmailNotConfirmedScreen.routeName: (ctx) =>
              EmailNotConfirmedScreen(_callSetState)
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            }),
      ),
    );
  }
}
