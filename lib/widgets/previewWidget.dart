import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/models/pixivillust.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:pxdart/pxdart.dart';

Widget previewWidget(
  PixivClient client,
  BuildContext context,
  List<Uint8List> images,
  Text title,
  bool isLoadingMore,
  int maxImages,
) {
  return Column(children: [
    Row(children: [title]),
    GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: maxImages,
      itemBuilder: (context, index) {
        if (index < images.length) {
          final illust = Image.memory(images[index]);
          return illust;
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Center(
                  child: isLoadingMore
                      ? const CircularProgressIndicator()
                      : Container()));
        }
      },
    )
  ]);
}
