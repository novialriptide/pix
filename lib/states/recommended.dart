import 'dart:typed_data';

import 'package:flutter/material.dart';
import './searchpage.dart';

class RecommendedScreen extends StatefulWidget {
  @override
  RecommendedState createState() => RecommendedState();
}

class RecommendedState extends State<RecommendedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
              child: Center(
                child: TextField(
                    readOnly: true,
                    textInputAction: TextInputAction.search,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search keyterm/ID',
                        prefixIcon: Icon(Icons.search))),
              ),
            ),
            shape: const ContinuousRectangleBorder()),
        body: Container());
  }
}
