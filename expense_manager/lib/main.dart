import 'package:flutter/cupertino.dart';

import '../cupertino_home_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool blueTheme = true;

  void changeTheme(bool brTh) {
    setState(() {
      blueTheme = brTh;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return blueTheme
        ? MaterialApp(
            title: 'Expense Manager',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomePage(
              blueTheme: blueTheme,
              changeTheme: changeTheme,
            ),
          )
        : CupertinoApp(
            title: 'Expense Manager',
            theme: CupertinoThemeData(
              primaryColor: Colors.blue,
              barBackgroundColor: Colors.blue[100],
              scaffoldBackgroundColor: Colors.blue[200],
            ),
            home: CupertinoHomePage(
              blueTheme: blueTheme,
              changeTheme: changeTheme,
            ),
          );
  }
}
