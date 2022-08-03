import 'package:flutter/material.dart';
import './seachoptions.dart';

class HomePageState extends State {
  @override
  Widget build(BuildContext context) {
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
                child: const Center(
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search keyterm/ID',
                          prefixIcon: Icon(Icons.search))),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 400,
                child: Center(
                  child: Text(
                    'No results',
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
