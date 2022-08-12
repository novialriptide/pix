import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:pxdart/pxdart.dart';
import './seachoptions.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<SearchScreen> {
  late PixivClient client;
  String searchKeyTerm = "";
  bool hasMore = false;
  bool isLoadingMore = false;
  List<PixivIllust> cachedIllusts = [];
  List<Uint8List> images = [];
  List<int> imageIds = [];
  int noPremiumPopularityIndex = 0;
  final scrollController = ScrollController();
  final textController = TextEditingController();

  @override
  void initState() {
    client = PixivClient();
    client.connect(refreshToken);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (noPremiumPopularityIndex > imageIds.length) {
          hasMore = false;
        }

        if (!isTop && hasMore && !isLoadingMore) {
          for (int i = 0; i < 5; i++) {
            loadRelatedImages(imageIds[noPremiumPopularityIndex],
                targetTag: searchKeyTerm);
            debugPrint(noPremiumPopularityIndex.toString());
            noPremiumPopularityIndex += 1;
          }
        }
      }
    });
    super.initState();
  }

  Future<Uint8List> loadImage(String unencodedPath) async {
    Uint8List out = await client.getIllustImageBytes(unencodedPath);
    return out;
  }

  Future<void> loadImages(String keyTerm) async {
    // Use getRelatedIllusts() to simulate Pixiv Premium
    isLoadingMore = true;
    List<Uint8List> widgets = [];
    List illusts = await client.getPopularPreviewIllusts(keyTerm);

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }
      Uint8List img = await loadImage(illust.imageUrls['square_medium']);

      setState(() {
        hasMore = true;
        images.add(img);
        imageIds.add(illust.id);
        cachedIllusts.add(illust);
      });
    }

    isLoadingMore = false;
  }

  Future<void> loadRelatedImages(int illustId, {String? targetTag}) async {
    isLoadingMore = true;

    List<Uint8List> widgets = [];
    List illusts = await client.getIllustRelated(illustId);

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }
      Uint8List img = await loadImage(illust.imageUrls['square_medium']);

      setState(() {
        if (!imageIds.contains(illust.id)) {
          if (targetTag == null) {
            return;
          }

          List<String> illustTags = [];
          for (Map tag in illust.jsonTags) {
            illustTags.add((tag['name'] as String).toLowerCase());
            if (tag['translated_name'] != null) {
              illustTags.add((tag['translated_name'] as String).toLowerCase());
            }
          }
          if (illustTags.contains(targetTag.toLowerCase())) {
            images.add(img);
            imageIds.add(illust.id);
            cachedIllusts.add(illust);
          }
        }
      });
    }

    isLoadingMore = false;
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
                    controller: textController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      searchKeyTerm = textController.text;
                      images = [];
                      imageIds = [];
                      cachedIllusts = [];
                      loadImages(textController.text);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search keyterm/ID',
                        prefixIcon: Icon(Icons.search))),
              ),
            ),
            shape: const ContinuousRectangleBorder(),
            actions: [
              IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchOptions()));
                  })
            ]),
        body: GridView.builder(
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              if (index < images.length) {
                final illust = InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IllustViewScreen(
                                  illust: cachedIllusts[index],
                                  client: client)));
                    },
                    child: Image.memory(images[index]));
                return illust;
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                      child: isLoadingMore
                          ? const CircularProgressIndicator()
                          : Container()),
                );
              }
            }));
  }
}
