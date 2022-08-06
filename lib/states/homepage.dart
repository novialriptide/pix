import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pxdart/pxdart.dart';
import './seachoptions.dart';

class HomePageState extends State {
  late PixivClient client;
  String searchKeyTerm = "";
  List<Uint8List> images = [];

  @override
  void initState() {
    client = PixivClient();
    client.connect("jSC-iVbHPw6-HZckMLpOrh7FbPohFLRa_7JoqNIxAVk");
    super.initState();
  }

  Future<Uint8List> loadImage(String unencodedPath) async {
    Uint8List out = await client.getIllustImageBytes(unencodedPath);
    return out;
  }

  Future loadImages(String keyTerm) async {
    // Use getRelatedIllusts() to simulate Pixiv Premium
    List<Uint8List> widgets = [];
    List illusts = await client.searchPopularPreviewIllusts(keyTerm);
    int a = 0;

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }
      Uint8List img = await loadImage(illust.imageUrls['square_medium']);
      // widgets.add(img);
      a += 1;

      setState(() {
        images.add(img);
      });
    }
  }

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
            final illust = Image.memory(images[index]);
            return illust;
          }),
    );
  }
}
