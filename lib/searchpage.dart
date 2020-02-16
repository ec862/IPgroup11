import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:template/BottomBar.dart';

final friendList = [
  "Elon Musk",
  "Jack Black",
  "Taylor Swift",
  "Christian Bale",
  "Matt Damon",
  "George Michael",
  "Django",
  'Maragaret Rotella'
      'Eboni Gehlert  '
      "Michel Proctor",
  "Stacy Dawn ",
  'Golda Mccawley',
  "Hattie Farina  ",
  "Dori Gallant  ",
  "Albertha Lawlor ",
  " Suzette Meunier ",
  " Malia Bartlow  ",
  " Anissa Rutland  ",
  "Margie Close  ",
  " Melonie Montez ",
  " Lauri Boyers  ",
  " Ira Wheeler  ",
  " Kristine Hennessee  ",
  "Una Ressler  ",
  " Elidia Rahim  ",
  " Ayana Nussbaum  ",
  " Bibi Brunson  ",
  " Dayle Mccardle  ",
  " Dong Goetz  ",
  " Lael Waddle  ",
  " Lavone Sowa  ",
  " Brigid Schneiderman  ",
  " Roxie Mondor  ",
  " May Berardi  ",
  " Chong Hanke  ",
  " Rosalee Spain ",
  " Latashia Escamilla  ",
  " Nickie Spindler  ",
  " Shaquana Schapiro  ",
  " Ellis Koons  ",
  ' Emory Owens  '
      ' Amal Filice  ',
  " Adina Ali  ",
  " Julieann Heil ",
  " Chelsea Hankey ",
  " Penni Gains  ",
  " Arla Brazee  ",
  " Valda Lotz  ",
  " Rossana Hodgin  ",
  " Jacob Larrimore ",
  " Caleb Dillahunt",
  " Kathryn Deaner",
  " Jaqueline Yip",
  " Lucy Lucian ",
  " Edra Blow  ",
  " Ouida Center ",
  "Emogene Marlin ",
];

final movieList = [
  "Dark Knight",
  "Despicable Me",
  "Shrek",
  "Avengers",
  "Alien",
  "Dark Knight Rises",
  "Django",
  "Batman v Superman: Dawn of Justice",
  "Dunkirk",
  "Inception",
  "Insomnia",
  "Interstellar",
  "Justice League",
  "Larceny",
  "Man of Steel",
  "Memento",
  "The Prestige",
  "Quay",
  "Get Out",
  "1917",
  "Mamma Mia",
  "Finding Nemo",
];

HashSet<String> friendHistorySet = new HashSet();
HashSet<String> movieHistorySet = new HashSet();

class MovieSearchPage extends StatefulWidget {
  String title = "Movie Search Page";
  String otherPage = '/friendsearchpage';
  Icon otherIcon = Icon(Icons.people);
  Icon icon = Icon(Icons.movie);
  HashSet<String> elementSet = movieHistorySet;
  List<String> elementList = movieList;

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class FriendSearchPage extends StatefulWidget {
  String title = "Friend Search Page";
  String otherPage = '/moviesearchpage';
  Icon otherIcon = Icon(Icons.movie);
  Icon icon = Icon(Icons.people);
  HashSet<String> elementSet = friendHistorySet;
  List<String> elementList = friendList;

  @override
  _FriendSearchPageState createState() => _FriendSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      widget.elementList, widget.icon, widget.elementSet),
                );
              }),
          IconButton(
            icon: widget.otherIcon,
            onPressed: () {
              Navigator.popAndPushNamed(context, widget.otherPage);
            },
          )
        ],
      ),
      bottomNavigationBar: BottomBar().createBar(context, 1),
    );
  }
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      widget.elementList, widget.icon, widget.elementSet),
                );
              }),
          IconButton(
            icon: widget.otherIcon,
            onPressed: () {
              Navigator.popAndPushNamed(context, widget.otherPage);
            },
          )
        ],
      ),
      bottomNavigationBar: BottomBar().createBar(context, 1),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  List<String> suggestionList;
  List<String> elementList;
  Icon icon;
  HashSet<String> searchHistorySet;

  CustomSearchDelegate(this.elementList, this.icon, this.searchHistorySet);

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
    suggestionList = query.isEmpty
        ? searchHistorySet.toList()
        : elementList
            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    if (suggestionList.length > 1) {
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              leading: icon,
              title: Text(suggestionList[index]),
              onTap: () {
                query = suggestionList[index];
                searchHistorySet.add(query);
                return TestingPage.createPage(query);
              },
            ),
        itemCount: suggestionList.length,
      );
    } else if (suggestionList.length == 1) {
      return TestingPage.createPage(query);
    } else {
      return TestingPage.createPage("No results");
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionList = query.isEmpty
        ? searchHistorySet.toList()
        : elementList
            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            leading: icon,
            title: Text(suggestionList[index]),
            onTap: () {
              query = suggestionList[index];
              searchHistorySet.add(query);
              showResults(context);
            },
          ),
      itemCount: suggestionList.length,
    );
  }
}

class TestingPage {
  static Center createPage(String title) {
    return Center(
      child: Container(
          height: 300,
          width: 300,
          color: Colors.orange,
          child: Center(
              child: Text(
            title,
            style: TextStyle(fontSize: 30),
          ))),
    );
  }
}
