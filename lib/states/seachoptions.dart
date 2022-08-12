import 'package:flutter/material.dart';

class SearchOptions extends StatefulWidget {
  @override
  SearchOptionsState createState() => SearchOptionsState();
}

class SearchOptionsState extends State<SearchOptions> {
  @override
  Widget build(BuildContext context) {
    String sortDropDownValue = 'Popularity (Non-Premium)';
    String durationDropDownValue = 'none';
    List<Widget> stuff = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                labelStyle: TextStyle(),
                labelText: 'Sort by'),
            key: const Key('sort'),
            value: sortDropDownValue,
            items: <String>[
              'Popularity (Non-Premium)', // Custom Search
              'Popularity', // popular_desc
              'Date Ascending', // date_asc
              'Date Descending' // date_desc
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => {}),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Options'),
        ),
        body: SizedBox(
            height: 400,
            child: Center(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stuff.length,
                    itemBuilder: (BuildContext context, int index) {
                      return stuff[index];
                    }))));
  }
}
