import 'package:flutter/material.dart';
import 'package:nakiapp/states/login.dart';

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
          primaryColor: Colors.lightBlue,
        ),
        home: LoginScreen());
  }
}
