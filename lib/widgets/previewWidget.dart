import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:nakiapp/models/pixivillust.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:nakiapp/widgets/illustChildGrid.dart';
import 'package:pxdart/pxdart.dart';

Widget previewWidget(
  PixivClient client,
  BuildContext context,
  List<CachedIllustResult> cachedIllustResults,
  Text title,
  bool isLoadingMore,
  int maxIllusts,
) {
  return Column(children: [
    Row(children: [title]),
    GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: maxIllusts,
      itemBuilder: (context, index) {
        if (index < cachedIllustResults.length) {
          final illust =
              illustChildGrid(context, cachedIllustResults[index], client);
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
