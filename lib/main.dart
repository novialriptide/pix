import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nakiapp/states/login.dart';

void main() {
  bool isInDebugMode = false;

  FlutterError.onError = (FlutterErrorDetails details) async {
    final dynamic exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
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
