import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:pxdart/pxdart.dart';

import '../states/illustview.dart';

Widget illustChildGrid(BuildContext context,
    CachedIllustResult cachedIllustResult, PixivClient client) {
  return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IllustViewScreen(
                    illust: cachedIllustResult.illust, client: client)));
      },
      child: Image.memory(cachedIllustResult.image));
}
