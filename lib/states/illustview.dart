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
        body: ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: FutureBuilder<Uint8List>(
                future: getImage(),
                builder:
                    (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                  } else {
                    return const Text('lmao');
                  }
                })));
  }
}

/*
*/