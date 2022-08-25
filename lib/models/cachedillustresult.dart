import 'dart:typed_data';

import 'package:nakiapp/models/pixivillust.dart';

class CachedIllustResult {
  Uint8List image;
  int id;
  PixivIllust illust;

  CachedIllustResult(this.image, this.id, this.illust);
}
