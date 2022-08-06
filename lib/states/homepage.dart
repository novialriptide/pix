import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pxdart/pxdart.dart';
import './seachoptions.dart';

class HomePageState extends State {
  late PixivClient client;
  String searchKeyTerm = "";
  List<Widget> images = [];

  Future loadImage(String unencodedPath) async {
    Image image = Image.memory(await client.getIllustImageBytes(unencodedPath));
    return image;
  }

  Future loadImages(String keyTerm) async {
    List<Widget> widgets = [];
    List illusts = await client.searchPopularPreviewIllusts(keyTerm);
    int a = 0;

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }
      Image img = await loadImage(illust.imageUrls['medium']);
      widgets.add(img);
      a += 1;
    }

    setState(() {
      images = widgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    client = PixivClient();
    client.connect("jSC-iVbHPw6-HZckMLpOrh7FbPohFLRa_7JoqNIxAVk");

    return Scaffold(
      appBar: AppBar(
          title: Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
            child: Center(
              child: TextField(
                  onSubmitted: (value) {
                    loadImages(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search keyterm/ID',
                      prefixIcon: Icon(Icons.search))),
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchOptionsState()));
                })
          ]),
      body: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            final illust = images[index];
            return illust;
          }),
    );
  }
}
