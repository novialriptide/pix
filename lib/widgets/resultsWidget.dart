import 'package:flutter/material.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:nakiapp/widgets/illustChildGrid.dart';
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
            final illust =
                illustChildGrid(context, cachedIllustResults[index], client);
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
