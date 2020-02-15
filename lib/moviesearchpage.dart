import 'package:flutter/material.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Movie Search Page'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              }),
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/friendsearchpage');
            },
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final movieList = [
    "Dark Knight",
    "Despicable Me",
    "Shrek",
    "Avengers",
    "Alien",
    "Dark Knight Rises",
    "Django"
  ];
  final searchHistoryList = ["Justice League"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(height: 100, child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? searchHistoryList
        : movieList
            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.movie),
            title: Text(suggestionList[index]),
            onTap: () {
              query = suggestionList[index];
              searchHistoryList.add(query);
              showResults(context);
            },
          ),
      itemCount: suggestionList.length,
    );
  }
}
