import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nakiapp/models/pixivuser.dart';
import 'package:pxdart/pxdart.dart';

class ProfileViewScreen extends StatelessWidget {
  ProfileViewScreen({super.key, required this.profile, required this.client});

  final PixivClient client;
  final PixivUser profile;

  ScrollController scrollController = ScrollController();

  Future<Uint8List> getUserImage() async {
    return await client.getIllustImageBytes(profile.profileImageUrls['medium']);
  }

  Future<Uint8List> getUserBackground() async {
    debugPrint(profile.backgroundImageUrl);
    return await client.getIllustImageBytes(profile.backgroundImageUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.userName),
      ),
      body: Align(
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
                                  image: Image.memory(snapshot.data!).image),
                            ),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.0),
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
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
        ]),
      ),
    );
  }
}
