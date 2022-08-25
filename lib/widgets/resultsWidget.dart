import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:pxdart/pxdart.dart';

Widget resultsWidget(
    PixivClient client,
    BuildContext context,
    List<CachedIllustResult> cachedIllustResults,
    ScrollController scrollController,
    int crossAxisCount,
    bool isLoadingMore) {
  return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: cachedIllustResults.length + 1,
      itemBuilder: (context, index) {
        if (index < cachedIllustResults.length) {
          try {
            final illust = InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IllustViewScreen(
                              illust: cachedIllustResults[index].illust,
                              client: client)));
                },
                child: Image.memory(cachedIllustResults[index].image));
            return illust;
          } catch (e) {
            return Container();
          }
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Center(
                  child: isLoadingMore
                      ? const CircularProgressIndicator()
                      : Container()));
        }
      });
}
