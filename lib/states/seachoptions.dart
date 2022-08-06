import 'package:flutter/material.dart';

class SearchOptionsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String sortDropDownValue = 'popular_desc';
    String durationDropDownValue = 'none';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text('Search Options'),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 400,
                child: Center(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              labelStyle: TextStyle(),
                              labelText: 'Sort'),
                          key: const Key('sort'),
                          value: sortDropDownValue,
                          items: <String>[
                            'popular_desc',
                            'date_desc',
                            'date_asc'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) => {}),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              labelStyle: TextStyle(),
                              labelText: 'Duration'),
                          key: const Key('duration'),
                          value: durationDropDownValue,
                          items: <String>[
                            'none',
                            'within_last_day',
                            'within_last_week',
                            'within_last_month'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) => {}),
                    )
                  ]),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
