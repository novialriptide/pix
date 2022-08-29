import 'package:flutter/material.dart';
import 'package:pxdart/pxdart.dart';
import './searchpage.dart';

class RecommendedScreen extends StatefulWidget {
  PixivClient client;

  RecommendedScreen(this.client, {Key? key}) : super(key: key);
  @override
  RecommendedState createState() => RecommendedState(client);
}

class RecommendedState extends State<RecommendedScreen> {
  PixivClient client;

  RecommendedState(this.client);

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
                              builder: (context) => SearchScreen(client)));
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
