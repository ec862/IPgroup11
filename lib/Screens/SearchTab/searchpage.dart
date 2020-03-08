import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
List data = new List();
String lastQuery = "zzzz";
Widget lastWidget;

class MovieSearch {
  Future getMovieData(String movieSearch) async {
    StringBuffer url = new StringBuffer(
        "http://www.omdbapi.com/?apikey=80246e40&type=movie&s=" +
            movieSearch.replaceAll(" ", "*") +
            "*");

    var res = await http.get(Uri.parse(url.toString()));
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

    if (movieSearch == lastQuery) {
      return data;
    }
    lastQuery = movieSearch;

    List lData = resBody["Search"];
    data = new List();
    int results = int.parse(resBody["totalResults"]);
    int pageNumber;
    int maxPage = 5;
    if (results > maxPage * 10) {
      pageNumber = maxPage;
    } else {
      pageNumber = results ~/ 10 + ((results % 10 == 0) ? 0 : 1);
    }
    StringBuffer tempUrl;

    for (int i = 2; i <= pageNumber; i++) {
      tempUrl = new StringBuffer(url);
      tempUrl.write("&page=");
      tempUrl.write(i.toString());
      res = await http.get(Uri.parse(tempUrl.toString()));
      resBody = json.decode(res.body);
      if (resBody["Response"] != "False") {
        lData.insertAll(lData.length, resBody["Search"]);
      } else {
        break;
      }
    }
    for (int i = 0; i < lData.length; i++) {
      var temp = lData[i];
      MovieObject m = new MovieObject(
          temp["Title"], temp["imdbID"], temp["Year"], temp["Poster"]);
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

  Widget createSearchPage(BuildContext context, String query) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Movies",
                ),
                Tab(
                  text: "People",
                )
              ],
              labelColor: Colors.black,
            ),
            body: TabBarView(children: <Widget>[
              createMovieSearch(context, query),
              createMovieSearch(context, query)
            ])));
  }

  Widget createRecentMovieSearch(BuildContext context) {
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

  Widget createMovieSearch(BuildContext context, String query) {
    if (query == "" || query == null) {
      return createRecentMovieSearch(context);
    } else if (query == lastQuery) {
      return lastWidget;
    } else {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else if (projectSnap.data == -1 ||
              projectSnap.data == -2 ||
              projectSnap.data == -3 ||
              projectSnap.data == -4) {
            String s;
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
            lastWidget = Center(
              child: Container(
                child: Text(s),
              ),
            );
            return lastWidget;
          } else if (projectSnap.hasError) {
            lastWidget = Center(
              child: Container(
                child: Text("Error with query"),
              ),
            );
            return lastWidget;
          } else {
            lastWidget = ListView.builder(
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
            return lastWidget;
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
    return createSearchPage(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return createSearchPage(context, query);
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
