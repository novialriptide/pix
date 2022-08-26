import 'package:flutter/material.dart';
import 'package:nakiapp/models/pixivillust.dart';
import 'package:nakiapp/states/illustview.dart';
import 'package:pxdart/pxdart.dart';

Widget previewWidget(
  PixivClient client,
  BuildContext context,
  List<PixivIllust> illusts,
  String title,
  bool isLoadingMore,
) {
  return Column(children: [
    Row(children: [Text(title)]),
    GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: illusts.length,
      itemBuilder: (context, index) {
        if (index < illusts.length) {
          try {
            final illust = InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IllustViewScreen(
                                illust: illusts[index],
                                client: client,
                              )));
                },
                child: Image.memory(illusts[index].imageUrls['medium_square']));
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
      },
    )
  ]);
}
