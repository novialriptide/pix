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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(illust.title)),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
              child: FutureBuilder<Uint8List>(
                  future: getImage(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(snapshot.data!);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
          Container(
              color: Colors.grey[100],
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(illust.displayName),
                                Text(illust.userName,
                                    style: const TextStyle(fontSize: 13.5))
                              ]),
                        )
                      ]),
                      Text(illust.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      Text(illust.caption)
                    ],
                  )))
        ]));
  }
}

/*
*/
