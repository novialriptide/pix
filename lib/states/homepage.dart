import 'package:flutter/material.dart';
import 'package:pxdart/pxdart.dart';
import './seachoptions.dart';

class HomePageState extends State {
  late PixivClient client;
  String searchKeyTerm = "";
  List<Widget> images = [];

  Future<List<Widget>> loadImages(String keyTerm) async {
    List<Widget> widgets = [];
    List illusts = await client.searchIllust(keyTerm) as List<PixivIllust>;

    for (var illust in illusts) {
      Image img = Image.network(illust.imageUrls[0]);
      widgets.add(img);
    }

    return widgets as Future<List<Widget>>;
  }

  @override
  Widget build(BuildContext context) {
    client = PixivClient();
    client.connect("jSC-iVbHPw6-HZckMLpOrh7FbPohFLRa_7JoqNIxAVk");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: const Text('nakiapp'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchOptionsState()));
                },
              ),
            ],
            bottom: AppBar(
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: Center(
                  child: TextField(
                      onSubmitted: (value) {
                        searchKeyTerm = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search keyterm/ID',
                          prefixIcon: Icon(Icons.search))),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                  height: 400, child: Center(child: Row(children: images))),
            ]),
          ),
        ],
      ),
    );
  }
}
