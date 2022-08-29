import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/models/cachedillustresult.dart';
import 'package:nakiapp/utils.dart';
import 'package:nakiapp/widgets/resultsWidget.dart';
import 'package:pxdart/pxdart.dart';
import '../models/pixivillust.dart';
import './seachoptions.dart';

class SearchScreen extends StatefulWidget {
  PixivClient client;

  SearchScreen(this.client, {Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState(client);
}

class SearchState extends State<SearchScreen> {
  PixivClient client;
  String searchKeyTerm = "";
  String incompleteSearchTerm = "";
  bool hasMore = false;
  bool isLoadingMore = false;
  bool showSuggests = true;

  List<CachedIllustResult> cachedIllustResults = [];

  List<Map<String, dynamic>> suggestions = [];
  int noPremiumPopularityIndex = 0;
  final scrollController = ScrollController();
  final textController = TextEditingController();

  SearchState(this.client);

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        List<int> imageIds = [];
        for (CachedIllustResult result in cachedIllustResults) {
          imageIds.add(result.id);
        }
        bool isTop = scrollController.position.pixels == 0;
        if (noPremiumPopularityIndex > imageIds.length) {
          hasMore = false;
        }

        if (!isTop && hasMore && !isLoadingMore) {
          for (int i = 0; i < 5; i++) {
            loadRelatedImages(imageIds[noPremiumPopularityIndex],
                targetTag: searchKeyTerm);
            debugPrint(noPremiumPopularityIndex.toString());
            noPremiumPopularityIndex += 1;
          }
        }
      }
    });
    super.initState();
  }

  bool isDisplayingResults() {
    return searchKeyTerm.isNotEmpty && incompleteSearchTerm.isEmpty;
  }

  void submitSearch(String keyTerm) {
    if (keyTerm.isNotEmpty) {
      showSuggests = false;
      searchKeyTerm = textController.text;
      cachedIllustResults = [];
      incompleteSearchTerm = '';
      if (searchKeyTerm.isNotEmpty) {
        loadImages(textController.text);
      }
    }
  }

  void resetSearch() {
    searchKeyTerm = '';
    cachedIllustResults = [];
    incompleteSearchTerm = '';
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<Uint8List> loadImage(String unencodedPath) async {
    Uint8List out = await client.getIllustImageBytes(unencodedPath);
    return out;
  }

  Future<void> updateAutoComplete() async {
    if (incompleteSearchTerm.isEmpty) {
      setStateIfMounted(() {
        suggestions = [];
      });
      return;
    }

    var response = await client.getSearchAutoCompleteV2(incompleteSearchTerm);

    setStateIfMounted(() {
      suggestions = List<Map<String, dynamic>>.from(response['tags']);
    });
  }

  Future<void> loadImages(String keyTerm) async {
    // Use getRelatedIllusts() to simulate Pixiv Premium
    isLoadingMore = true;
    List<Uint8List> widgets = [];
    List illusts = await getPopularPreviewIllusts(client, keyTerm);

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }
      Uint8List img = await loadImage(illust.imageUrls['square_medium']);

      setStateIfMounted(() {
        hasMore = true;
        cachedIllustResults.add(CachedIllustResult(img, illust.id, illust));
      });
    }

    isLoadingMore = false;
  }

  Future<void> loadRelatedImages(int illustId, {String? targetTag}) async {
    isLoadingMore = true;

    List<Uint8List> widgets = [];
    List illusts = await getIllustRelated(client, illustId);

    for (PixivIllust illust in illusts) {
      if (illust.imageUrls['square_medium'] == null) {
        continue;
      }

      Uint8List img = await loadImage(illust.imageUrls['square_medium']);

      if (img.isEmpty) {
        continue;
      }

      setStateIfMounted(() {
        List<int> imageIds = [];
        for (CachedIllustResult result in cachedIllustResults) {
          imageIds.add(result.id);
        }

        if (!imageIds.contains(illust.id)) {
          if (targetTag == null) {
            return;
          }

          List<String> illustTags = [];
          for (Map tag in illust.jsonTags) {
            illustTags.add((tag['name'] as String).toLowerCase());
            if (tag['translated_name'] != null) {
              illustTags.add((tag['translated_name'] as String).toLowerCase());
            }
          }
          if (illustTags.contains(targetTag.toLowerCase())) {
            cachedIllustResults.add(CachedIllustResult(img, illust.id, illust));
          }
        }
      });
    }

    isLoadingMore = false;
  }

  Widget suggestionsWidget(BuildContext context) {
    return suggestions.isEmpty
        ? const Center(child: Text('Nothing to suggest.'))
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: ((context, index) {
              String name = suggestions[index]['name'];
              String? translatedName = suggestions[index]['translated_name'];
              if (suggestions[index]['translated_name'] != null) {
                return ListTile(
                    title: Text(name),
                    subtitle: Text(translatedName!),
                    onTap: () {
                      textController.text = name;
                      submitSearch(name);
                    });
              } else {
                return ListTile(
                    title: Text(name),
                    onTap: () {
                      textController.text = name;
                      submitSearch(name);
                    });
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
              child: Center(
                child: TextField(
                    autofocus: true,
                    controller: textController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onChanged: ((value) {
                      incompleteSearchTerm = value;
                      updateAutoComplete();
                    }),
                    onSubmitted: (_) {
                      submitSearch(textController.text);
                    },
                    onTap: () {
                      showSuggests = true;
                    },
                    onEditingComplete: () {
                      showSuggests = false;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search keyterm/ID',
                        prefixIcon: Icon(Icons.search))),
              ),
            ),
            shape: const ContinuousRectangleBorder(),
            actions: [
              IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchOptions()));
                  })
            ]),
        body: !showSuggests
            ? resultsWidget(client, context, cachedIllustResults,
                scrollController, 2, isLoadingMore)
            : suggestionsWidget(context));
  }
}
