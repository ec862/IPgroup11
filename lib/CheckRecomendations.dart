import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/MovieScreen.dart';

import 'BottomBar.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class CheckRecomendations extends StatefulWidget {
  @override
  _CheckRecomendationsState createState() => _CheckRecomendationsState();
}

class _CheckRecomendationsState extends State<CheckRecomendations> {
  int currentindex = 0; // home = 0
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      movies.add(Movie());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Check Recommendations'),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (ctx, index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(movies[index].profilePic),
                        fit: BoxFit.fitWidth),
                  ),
                ),
                ListTile(
                  title: Text("${_getShorterText(movies[index].movieName)}"),
                  subtitle: Text(
                    "${_getShorterText(movies[index].synopsis)}",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return MovieScreen();
                    }));
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar().createBar(context, 2),
    );
  }

  String _getShorterText(String text) {
    String toReturn = text;
    int maxLen = 45;
    if (text.length >= maxLen) {
      toReturn = toReturn.substring(0, maxLen);
      toReturn += " ...";
    }
    return toReturn;
  }
}

class Movie {
  String profilePic;
  String movieName;
  List<dynamic> genres = [];
  List<dynamic> directors = [];
  List<dynamic> actors = [];
  String synopsis;

  Movie({
    this.profilePic = "asserts/AvengersPoster.jpg",
    this.movieName = "AVENGERS ENDGAME",
    this.genres,
    this.directors,
    this.actors,
    this.synopsis = "The avengers have lost to thanos and they have to "
        "find a way to bring them back to life",
  });
}
