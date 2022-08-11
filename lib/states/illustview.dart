import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/states/homepage.dart';
import 'package:pxdart/pxdart.dart';

class IllustViewScreen extends StatelessWidget {
  const IllustViewScreen(
      {super.key, required this.illust, required this.client});

  final PixivClient client;
  final PixivIllust illust;

  Future<Uint8List> getImage() async {
    return await client.getIllustImageBytes(illust.imageUrls['large']);
  }

  Future<Uint8List> getUserImage() async {
    return await client.getIllustImageBytes(illust.userProfileImages['medium']);
  }

  Widget getTagModel(RichText richText) {
    return Chip(
      label: richText,
      backgroundColor: Colors.lightBlueAccent,
    );
  }

  List<Widget> getTagsAsWidgets() {
    List<Widget> widgets = [];

    for (Map tag in illust.jsonTags) {
      String name = tag["name"];
      String? translatedName = tag["translated_name"];
      if (tag["translated_name"] != null) {
        widgets.add(getTagModel(RichText(
            text: TextSpan(children: [
          TextSpan(text: "#${name} "),
          TextSpan(
              text: tag["translated_name"],
              style: const TextStyle(color: Colors.white70))
        ]))));
      } else {
        widgets.add(getTagModel(RichText(
            text: TextSpan(children: [
          TextSpan(text: "#${name} "),
        ]))));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(illust.title)),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
            child: FutureBuilder<Uint8List>(
                future: getImage(),
                builder:
                    (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          child: Chip(
                              avatar: FutureBuilder<Uint8List>(
                                  future: getUserImage(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Uint8List> snapshot) {
                                    if (snapshot.hasData) {
                                      return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.memory(snapshot.data!));
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  }),
                              label: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(illust.displayName),
                                    Text(illust.userName,
                                        style: const TextStyle(fontSize: 13.5))
                                  ]))),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          child: const Chip(label: Text("Follow"))),
                    ])),
                Text(illust.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                Text(illust.caption),
                Wrap(
                    spacing: 5.0,
                    runSpacing: -7.0,
                    direction: Axis.horizontal,
                    children: getTagsAsWidgets()),
              ],
            ))
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
