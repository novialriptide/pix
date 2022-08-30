import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:nakiapp/utils.dart';
import 'package:nakiapp/widgets/resultsWidget.dart';
import 'package:pxdart/pxdart.dart';
import '../models/pixivillust.dart';
import '../models/pixivuser.dart';
import './seachoptions.dart';

class ProfileIllustViewScreen extends StatefulWidget {
  PixivClient client;
  PixivUser profile;

  ProfileIllustViewScreen(this.client, this.profile, {Key? key})
      : super(key: key);

  @override
  ProfileIllustViewState createState() =>
      ProfileIllustViewState(client, profile);
}

class ProfileIllustViewState extends State<ProfileIllustViewScreen> {
  PixivClient client;
  PixivUser profile;
  int offset = 0;
  bool hasMore = false;
  bool isLoadingMore = false;

  List<CachedIllustResult> cachedIllustResults = [];

  final scrollController = ScrollController();

  ProfileIllustViewState(this.client, this.profile);

  @override
  void initState() {
    loadImages();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        List<int> imageIds = [];
        for (CachedIllustResult result in cachedIllustResults) {
          imageIds.add(result.id);
        }
        bool isTop = scrollController.position.pixels == 0;

        if (!isTop && hasMore && !isLoadingMore) {
          offset += 30;
          loadImages();
        }
      }
    });
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<Uint8List> loadImage(String unencodedPath) async {
    Uint8List out = await client.getIllustImageBytes(unencodedPath);
    return out;
  }

  Future<int> loadImages() async {
    // Use getRelatedIllusts() to simulate Pixiv Premium
    isLoadingMore = true;
    List<Uint8List> widgets = [];
    List illusts = await getUserIllusts(client, profile.userId, offset: offset);

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }
      Uint8List img = await loadImage(illust.imageUrls['square_medium']);

      setStateIfMounted(() {
        hasMore = true;
        cachedIllustResults.add(CachedIllustResult(img, illust.id, illust));
      });
    }

    isLoadingMore = false;

    if (illusts.length < 30) {
      hasMore = false;
    }

    return illusts.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: resultsWidget(client, context, cachedIllustResults,
          scrollController, 2, isLoadingMore),
    );
  }
}
