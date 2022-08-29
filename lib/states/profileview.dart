import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:nakiapp/models/pixivillust.dart';
import 'package:nakiapp/models/pixivuser.dart';
import 'package:nakiapp/utils.dart';
import 'package:nakiapp/widgets/previewWidget.dart';
import 'package:pxdart/pxdart.dart';

class ProfileViewScreen extends StatelessWidget {
  ProfileViewScreen({super.key, required this.profile, required this.client});

  final PixivClient client;
  final PixivUser profile;

  ScrollController scrollController = ScrollController();

  List<PixivIllust> previewIllusts = [];
  bool isLoadingMoreIllusts = false;

  Future<Uint8List> getUserImage() async {
    return await client.getIllustImageBytes(profile.profileImageUrls['medium']);
  }

  Future<List<Uint8List>> getPreviewImages(int quantity) async {
    List<PixivIllust> illusts = await getUserIllusts(client, profile.userId);
    List<Uint8List> images = [];
    for (int i = 0; i < quantity; i++) {
      images.add(await client
          .getIllustImageBytes(illusts[i].imageUrls['square_medium']));
    }

    return images;
  }

  Future<Uint8List> getUserBackground() async {
    if (profile.backgroundImageUrl == null) {
      return await client
          .getIllustImageBytes(profile.profileImageUrls['medium']);
    }
    return await client.getIllustImageBytes(profile.backgroundImageUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(profile.userName),
        ),
        body: Align(
          child: Column(children: [
            SizedBox(
                height: 200,
                child: Stack(children: [
                  Positioned(
                      top: 0.0,
                      right: 0.0,
                      left: 0.0,
                      child: SizedBox(
                          child: FutureBuilder<Uint8List>(
                              future: getUserBackground(),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<Uint8List> snapshot,
                              ) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: 145,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          alignment: FractionalOffset.center,
                                          image: Image.memory(snapshot.data!)
                                              .image),
                                    ),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 0.0, sigmaY: 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.0),
                                          ),
                                        )),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              }))),
                  Positioned(
                      top: 105.0,
                      left: MediaQuery.of(context).size.width / 2 - 80 / 2 - 10,
                      child: FutureBuilder<Uint8List>(
                        future: getUserImage(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<Uint8List> snapshot,
                        ) {
                          if (snapshot.hasData) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[50]!, width: 10),
                                    borderRadius: BorderRadius.circular(100.0)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.memory(
                                      snapshot.data!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      )),
                ])),
            Text(profile.displayName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(profile.comment),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0, left: 10.0, right: 10.0, top: 10),
              child: FutureBuilder<List>(
                future: getPreviewImages(6),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List> snapshot,
                ) {
                  if (snapshot.hasData) {
                    return previewWidget(
                      client,
                      context,
                      snapshot.data as List<Uint8List>,
                      const Text('Illustrations',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      isLoadingMoreIllusts,
                      6,
                    );
                  } else {
                    return const Text('Loading illustrations');
                  }
                },
              ),
            ),
          ]),
        ));
  }
}
