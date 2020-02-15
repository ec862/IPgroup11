import 'package:flutter/material.dart';

class FriendSearchPage extends StatefulWidget {
  @override
  _FriendSearchState createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearchPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Friend Search Page'),
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
            icon: Icon(Icons.movie),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/moviesearchpage');
            },
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final friendList = [
    "Elon Musk",
    "Jack Black",
    "Taylor Swift",
    "Christian Bale",
    "Matt Damon",
    "George Michael",
    "Django"
  ];
  final searchHistoryList = ["Elon Musk"];

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
        : friendList
            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.people),
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
