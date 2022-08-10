import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:nakiapp/states/login.dart';

import 'states/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'nakiapp',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: SearchScreen());
  }
}
