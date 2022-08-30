import 'package:pxdart/pxdart.dart';
import 'models/pixivillust.dart';

Future<dynamic> getPopularPreviewIllusts(
    PixivClient client, String word) async {
  var decodedResponse = await client.getPopularPreviewIllusts(word);

  List parsedIllusts = [];
  List illusts = decodedResponse["illusts"];
  for (int i = 0; i < illusts.length; i++) {
    parsedIllusts.add(PixivIllust.fromJson(illusts[i]));
  }

  return parsedIllusts;
}

Future<dynamic> getIllustRelated(PixivClient client, int illustId) async {
  Map decodedResponse = await client.getIllustRelated(illustId);
  List parsedIllusts = [];
  List illusts = decodedResponse["illusts"];
  for (int i = 0; i < illusts.length; i++) {
    parsedIllusts.add(PixivIllust.fromJson(illusts[i]));
  }

  return parsedIllusts;
}

Future<List<PixivIllust>> getUserIllusts(PixivClient client, int userId,
    {int offset = 0}) async {
  Map decodedResponse = await client.getUserIllusts(userId, offset: offset);
  List<PixivIllust> parsedIllusts = [];
  List illusts = decodedResponse["illusts"];
  for (int i = 0; i < illusts.length; i++) {
    parsedIllusts.add(PixivIllust.fromJson(illusts[i]));
  }

  return parsedIllusts;
}

Future<List> searchIllust(
  PixivClient client,
  String word, {
  String searchTarget = "partial_match_for_tags",
  String sort = "popular_desc",
  String duration = "",
  String startDate = "",
  String endDate = "",
  int offset = 0,
}) async {
  Map decodedResponse = await client.searchIllust(word,
      searchTarget: searchTarget,
      sort: sort,
      duration: duration,
      startDate: startDate,
      endDate: endDate,
      offset: offset);

  List parsedIllusts = [];
  List illusts = decodedResponse["illusts"];
  for (int i = 0; i < illusts.length; i++) {
    parsedIllusts.add(PixivIllust.fromJson(illusts[i]));
  }

  return parsedIllusts;
}
