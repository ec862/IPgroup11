import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/CustomView/BottomBar.dart';

final friendList = [
  "Elon Musk",
  "Jack Black",
  "Taylor Swift",
  "Christian Bale",
  "Matt Damon",
  "George Michael",
  "Django",
  'Maragaret Rotella',
  'Eboni Gehlert',
  "Michel Proctor",
  "Stacy Dawn",
  'Golda Mccawley',
  "Hattie Farina",
  "Dori Gallant",
  "Albertha Lawlor",
  "Suzette Meunier",
  "Malia Bartlow",
  "Anissa Rutland",
  "Margie Close",
  "Melonie Montez",
  "Lauri Boyers",
  "Ira Wheeler",
  "Kristine Hennessee",
  "Una Ressler",
  "Elidia Rahim",
  "Ayana Nussbaum",
  "Bibi Brunson",
  "Dayle Mccardle",
  "Dong Goetz",
  "Lael Waddle",
  "Lavone Sowa",
  "Brigid Schneiderman",
  "Roxie Mondor",
  "May Berardi",
  "Chong Hanke",
  "Rosalee Spain",
  "Latashia Escamilla",
  "Nickie Spindler",
  "Shaquana Schapiro",
  "Ellis Koons",
  'Emory Owens',
  'Amal Filice',
  "Adina Ali",
  "Julieann Heil",
  "Chelsea Hankey",
  "Penni Gains",
  "Arla Brazee",
  "Valda Lotz",
  "Rossana Hodgin",
  "Jacob Larrimore",
  "Caleb Dillahunt",
  "Kathryn Deaner",
  "Jaqueline Yip",
  "Lucy Lucian ",
  "Edra Blow  ",
  "Ouida Center ",
  "Emogene Marlin ",
];

final movieList = [
  "Shrek 2",
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

class SearchPage extends StatefulWidget {
  final String title = "Search Page";
  HashSet<String> movieElementSet = movieHistorySet;
  final List<String> movieElementList = movieList;
  HashSet<String> friendElementSet = friendHistorySet;
  final List<String> friendElementList = friendList;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String queryJson = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  widget.movieElementList,
                  widget.friendElementList,
                  widget.movieElementSet,
                  widget.friendElementSet,
                ),
              );
              SearchPageObject searchOb = SearchPageObject.fromJson(queryJson);

              if (searchOb.isMovie) {
                Navigator.pushNamed(context, '/moviepage');
              } else {
                Navigator.pushNamed(context, '/profile');
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomBar().createBar(context, 1),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  bool queryClickedMovie = false;
  bool queryClickedFriend = false;

  List<String> movieSuggestionList;
  List<String> friendSuggestionList;
  List<String> movieElementList;
  HashSet<String> movieHistorySet;
  List<String> friendElementList;
  HashSet<String> friendHistorySet;

  CustomSearchDelegate(this.movieElementList, this.friendElementList,
      this.movieHistorySet, this.friendHistorySet);

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
    return createSearchScreen(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return createSearchScreen(context);
  }

  Widget createSearchScreen(BuildContext context) {
    movieSuggestionList = query.isEmpty
        ? movieHistorySet.toList()
        : movieElementList
        .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    int msLength = movieSuggestionList.length;

    friendSuggestionList = query.isEmpty
        ? friendHistorySet.toList()
        : friendElementList
        .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    int fsLength = friendSuggestionList.length;

    SearchPageObject o;

    if (msLength + fsLength >= 1) {
      return ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0 || index == msLength + 1) {
            bool x = (index > 0) ? (fsLength > 0) : (msLength > 0);
            return (x
                ? ListTile(
              title: Text(((index > 0) ? "People" : "Movies"),
                  style: TextStyle(fontSize: 21)),
            )
                : SizedBox(
              height: 1,
            ));
          } else if (index < 1 + msLength) {
            o = new SearchPageObject(
                true, movieSuggestionList[index - 1], Icon(Icons.movie));
          } else {
            o = new SearchPageObject(false,
                friendSuggestionList[index - msLength - 2], Icon(Icons.people));
          }
          return ListTile(
              leading: o.icon,
              title: Text(
                o.queryString,
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                query = o.queryString;
                (o.isMovie)
                    ? movieHistorySet.add(query)
                    : friendHistorySet.add(query);
                close(context, o.toJson());
              });
        },
        itemCount: 2 + msLength + fsLength,
      );
    } else {
      return ListTile(
        title: Text(
          "No results",
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

class SearchPageObject {
  bool isMovie;
  String queryString;
  Icon icon;

  SearchPageObject(bool s, String queryS, Icon i) {
    isMovie = s;
    queryString = queryS;
    icon = i;
  }

  String toJson() {
    return json
        .encode({"isMovie": this.isMovie, "querryString": this.queryString});
  }

  static SearchPageObject fromJson(String maps) {
    var result = json.decode(maps);
    return SearchPageObject(
        result["isMovie"], result["querryString"], Icon(Icons.title));
  }
}
