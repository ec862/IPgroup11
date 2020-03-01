import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:http/http.dart' as http;
import 'package:template/Models/Arguments.dart';

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
LinkedHashSet<MovieObject> movieHistorySet =
    new LinkedHashSet(); // history of clicks, keeping their MovieObjects
Set data;
String lastQuery = "zzz";

class SearchPage extends StatefulWidget {
  final String title = "Search Page";

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
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              })
        ],
      ),
      bottomNavigationBar: BottomBar().createBar(context, 1),
    );
  }
}

class MovieSearch {
  Future getMovieData(String movieSearch) async {
    if (movieSearch == lastQuery) {
      return data;
    }
    lastQuery = movieSearch;
    final String url =
        "http://www.omdbapi.com/?apikey=80246e40&type=movie&page=1&s=" +
            movieSearch.replaceAll(" ", "*") +
            "*";
    var res = await http.get(Uri.parse(url));
    var resBody = json.decode(res.body);

    if (resBody["Response"] == "False") {
      if (resBody["Error"] == "Too many results.") {
        return -1;
      } else if (resBody["Error"] == "Movie not found!") {
        return -2;
      } else {
        return -3;
      }
    }
    List lData = resBody["Search"];
    data = Set();

    for (int i = 0; i < lData.length; i++) {
      MovieObject m = new MovieObject(lData[i]["Title"], lData[i]["imdbID"],
          lData[i]["Year"], lData[i]["Poster"]);
      data.add(m);
    }
    return data;
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  void addToMovieSet(MovieObject m) {
    if (movieHistorySet.length >= 20) {
      movieHistorySet.remove(movieHistorySet.remove(movieHistorySet.first));
    }
    movieHistorySet.add(m);
  }

  Widget createRecentSearch(BuildContext context) {
    if (movieHistorySet.length == 0) {
      return Center(
        child: Container(
          child: Text("Waiting for user input..."),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: movieHistorySet.length,
        itemBuilder: (context, index) {
          MovieObject m =
              movieHistorySet.elementAt(movieHistorySet.length - 1 - index);
          return ListTile(
            title: Text(m.movieTitle, style: TextStyle(fontSize: 21)),
            subtitle: Text(
              m.movieYear,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/moviepage',
                arguments: MovieScreenArguments(id: m.movieID),
              );
            },
            leading: Image.network(
              m.movieImageURL,
              height: 400,
              width: 40,
            ), //CircleAvatar(backgroundImage: NetworkImage(m.movieImageURL),),
          );
        },
      );
    }
  }

  Widget createSearch(BuildContext context, String query) {
    if (query == "" || query == null) {
      return createRecentSearch(context);
    } else {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                child: Text("Loading..."),
              ),
            );
          } else if (projectSnap.data == -1 ||
              projectSnap.data == -2 ||
              projectSnap.data == -3 ||
              projectSnap.data == -4) {
            String s;
            bool recent = false;

            switch (projectSnap.data) {
              case -1:
                {
                  s = "Too many results. Please specify title more.";
                  break;
                }
              case -2:
                {
                  s = "Movie with title \"" + query + "\" not found!";
                  break;
                }
              case -3:
                {
                  s = "Error.";
                  break;
                }
            }
            if (recent) {
              return createRecentSearch(context);
            }
            return Center(
              child: Container(
                child: Text(s),
              ),
            );
          } else if (projectSnap.hasError) {
            return Center(
              child: Container(
                child: Text("Error with query"),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                MovieObject m = projectSnap.data.elementAt(index);
                return ListTile(
                  title: Text(m.movieTitle, style: TextStyle(fontSize: 21)),
                  subtitle: Text(
                    m.movieYear,
                  ),
                  onTap: () {
                    addToMovieSet(m);
                    Navigator.pushNamed(
                      context,
                      '/moviepage',
                      arguments: MovieScreenArguments(id: m.movieID),
                    );
                  },
                  leading: Image.network(
                    m.movieImageURL,
                    height: 400,
                    width: 40,
                  ), //CircleAvatar(backgroundImage: NetworkImage(m.movieImageURL),),
                );
              },
            );
          }
        },
        future: MovieSearch().getMovieData(query),
      );
    }
  }

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
    return createSearch(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return createSearch(context, query);
  }

  Widget createSearchScreen(BuildContext context) {
//    movieSuggestionList = query.isEmpty
//        ? movieHistorySet.toList()
//        : movieElementList
//            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
//            .toList();
//    int msLength = movieSuggestionList.length;
//
//    friendSuggestionList = query.isEmpty
//        ? friendHistorySet.toList()
//        : friendElementList
//            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
//            .toList();
//
//    int fsLength = friendSuggestionList.length;
//
//    SearchPageObject o;
//
//    if (msLength + fsLength >= 1) {
//      return ListView.builder(
//        itemBuilder: (context, index) {
//          if (index == 0 || index == msLength + 1) {
//            bool x = (index > 0) ? (fsLength > 0) : (msLength > 0);
//            return (x
//                ? ListTile(
//                    title: Text(((index > 0) ? "People" : "Movies"),
//                        style: TextStyle(fontSize: 21)),
//                  )
//                : SizedBox(
//                    height: 1,
//                  ));
//          } else if (index < 1 + msLength) {
//            o = new SearchPageObject(
//                true, movieSuggestionList[index - 1], Icon(Icons.movie));
//          } else {
//            o = new SearchPageObject(false,
//                friendSuggestionList[index - msLength - 2], Icon(Icons.people));
//          }
//          return ListTile(
//              leading: o.icon,
//              title: Text(
//                o.queryString,
//                style: TextStyle(fontSize: 18),
//              ),
//              onTap: () {
//                query = o.queryString;
//                (o.isMovie)
//                    ? movieHistorySet.add(query)
//                    : friendHistorySet.add(query);
//                close(context, o.toJson());
//              });
//        },
//        itemCount: 2 + msLength + fsLength,
//      );
//    } else {
//      return ListTile(
//        title: Text(
//          "No results",
//          textAlign: TextAlign.center,
//        ),
//      );
//    }
  }
}

class MovieObject {
  String movieTitle;
  String movieID;
  String movieYear;
  String movieImageURL;

  MovieObject(mTitle, mID, mYear, mImage) {
    this.movieTitle = mTitle;
    this.movieID = mID;
    this.movieYear = mYear;
    this.movieImageURL = mImage;
  }

  String toJson() {
    return json.encode({
      "movieTitle": this.movieTitle,
      "movieID": this.movieID,
      "movieYear": this.movieYear,
      "movieImageURL": this.movieImageURL
    });
  }

  static MovieObject fromJson(String maps) {
    var result = json.decode(maps);
    return MovieObject(result["movieTitle"], result["movieID"],
        result["movieYear"], result["movieImageURL"]);
  }
}
