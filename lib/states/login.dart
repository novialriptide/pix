import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/states/homepage.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Refresh Token'),
        ),
        body: SizedBox(
            height: 400,
            child: Center(
              child: TextField(
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      refreshToken = value;
                    }
                    setState(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Refresh Token',
                      prefixIcon: Icon(Icons.search))),
            )));
  }
}
