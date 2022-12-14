import 'dart:io';
import 'dart:typed_data';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/models/pixivuser.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nakiapp/states/profileview.dart';
import 'package:pxdart/pxdart.dart';
import '../models/pixivillust.dart';

class IllustViewScreen extends StatelessWidget {
  IllustViewScreen({super.key, required this.illust, required this.client});

  final PixivClient client;
  final PixivIllust illust;
  PixivUser? pixivProfile = null;

  List<String> imageUrls = [];
  List<String> largeImageUrls = [];

  ScrollController illustScrollController = ScrollController();
  ScrollController infoScrollController = ScrollController();

  void getImages() {
    if (illust.jsonMetaSinglePage.isNotEmpty) {
      imageUrls.add(illust.imageUrls['medium']);
    }
    for (Map img in illust.jsonMetaPages) {
      imageUrls.add(img['image_urls']['medium']);
    }
  }

  void getLargeImages() {
    if (illust.jsonMetaSinglePage.isNotEmpty) {
      largeImageUrls.add(illust.imageUrls['large']);
    }
    for (Map img in illust.jsonMetaPages) {
      largeImageUrls.add(img['image_urls']['large']);
    }
  }

  Future<Uint8List> getUserImage() async {
    pixivProfile =
        PixivUser.fromJson(await client.getUserDetails(illust.userId));
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
                    if (pixivProfile != null) {
                      debugPrint('lmao');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileViewScreen(
                                  client: client, profile: pixivProfile!)));
                    } else if (pixivProfile == null) {
                      debugPrint('profile isnt loaded yet');
                    }
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
                          Text(illust.displayName)
                        ])
                  ]))
            ])));
  }

  Widget illustInfoWidget(BuildContext context) {
    DateTime dateTime = DateTime.parse(illust.creationDate);
    String dateTimeStr = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    double statsPaddingX = 8;

    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.only(
                bottom: 10.0, left: 10.0, right: 10.0, top: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(dateTimeStr),
                SizedBox(width: statsPaddingX),
                Text(illust.totalViews.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(" Views"),
                SizedBox(width: statsPaddingX),
                Text(illust.totalBookmarks.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(" Bookmarks")
              ]),
              const SizedBox(height: 10),
              const Text("Description",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(illust.caption.isNotEmpty
                  ? illust.caption
                  : 'No caption available'),
              const SizedBox(height: 10),
              const Text("Tags", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Wrap(
                  spacing: 5.0,
                  runSpacing: -7.0,
                  direction: Axis.horizontal,
                  children: getTagsAsWidgets()),
              const SizedBox(height: 70)
            ])));
  }

  void downloadImages() async {
    Map<String, String> header = client.getHeader();
    header["Referer"] = "https://app-api.pixiv.net/";
    for (String url in largeImageUrls) {
      await GallerySaver.saveImage(url, headers: header, albumName: albumName);
    }
  }

  @override
  Widget build(BuildContext context) {
    getImages();
    getLargeImages();
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.lightBlueAccent,
          // ignore: sort_child_properties_last
          child: illust.isBookmarked
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
        ),
        appBar: AppBar(
            title: Text(illust.id.toString()),
            shape: const ContinuousRectangleBorder(),
            actions: [
              IconButton(
                  icon: const Icon(Icons.file_download),
                  onPressed: () {
                    downloadImages();
                  }),
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
