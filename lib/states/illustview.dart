import 'dart:typed_data';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/states/searchpage.dart';
import 'package:pxdart/pxdart.dart';

class IllustViewScreen extends StatelessWidget {
  IllustViewScreen({super.key, required this.illust, required this.client});

  final PixivClient client;
  final PixivIllust illust;

  List<String> imageUrls = [];

  ScrollController illustScrollController = ScrollController();
  ScrollController infoScrollController = ScrollController();

  void getImages() {
    if (illust.jsonMetaSinglePage.isNotEmpty) {
      imageUrls.add(illust.imageUrls['large']);
    }
    for (Map img in illust.jsonMetaPages) {
      imageUrls.add(img['image_urls']['medium']);
    }
  }

  Future<Uint8List> getUserImage() async {
    return await client.getIllustImageBytes(illust.userProfileImages['medium']);
  }

  Widget getTagModel(RichText richText) {
    return Chip(
      label: richText,
      backgroundColor: Colors.lightBlue,
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

  Widget illustWidget(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: illust.pageCount,
          itemBuilder: (context, index) {
            return FutureBuilder<Uint8List>(
                future: client.getIllustImageBytes(imageUrls[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        color: Colors.red,
                        child: Image.memory(snapshot.data!, fit: BoxFit.cover));
                  } else if (snapshot.hasError) {
                    return Container();
                  } else {
                    return Container();
                  }
                });
          })
    ]);
  }

  Widget infoHeaderWidget(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: Row(children: [
                    SizedBox(
                        height: 35,
                        child: FutureBuilder<Uint8List>(
                            future: getUserImage(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Uint8List> snapshot) {
                              if (snapshot.hasData) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.memory(snapshot.data!));
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            })),
                    const SizedBox(width: 7),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(illust.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text("${illust.displayName} ${illust.userName}")
                        ])
                  ]))
            ])));
  }

  Widget illustInfoWidget(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.only(
                bottom: 10.0, left: 10.0, right: 10.0, top: 2.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(illust.caption.isNotEmpty
                  ? illust.caption
                  : 'No caption available'),
              Wrap(
                  spacing: 5.0,
                  runSpacing: -7.0,
                  direction: Axis.horizontal,
                  children: getTagsAsWidgets()),
              const SizedBox(height: 70)
            ])));
  }

  @override
  Widget build(BuildContext context) {
    getImages();
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.lightBlueAccent,
          child: const Icon(Icons.favorite_border),
        ),
        appBar: AppBar(shape: const ContinuousRectangleBorder(), actions: [
          IconButton(icon: const Icon(Icons.file_download), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu), onPressed: () {})
        ]),
        body: ExpandableBottomSheet(
          enableToggle: true,
          expandableContent: illustInfoWidget(context),
          background: SingleChildScrollView(
              controller: illustScrollController,
              child: Column(
                children: [illustWidget(context)],
              )),
          persistentHeader: infoHeaderWidget(context),
        ));
  }
}
