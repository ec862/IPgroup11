import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/Screens/MovieScreen.dart';

import '../CustomView/BottomBar.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class CheckRecomendations extends StatefulWidget {
  @override
  _CheckRecomendationsState createState() => _CheckRecomendationsState();
}

class _CheckRecomendationsState extends State<CheckRecomendations> {
  List<RecommendationInfo> movies = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      movies.add(RecommendationInfo());
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
                    "Recommended by: ${_getShorterText(movies[index].recBy)}".toUpperCase(),
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
    if (text == null)
      return "";

    if (text.length >= maxLen) {
      toReturn = toReturn.substring(0, maxLen);
      toReturn += " ...";
    }
    return toReturn;
  }
}

class RecommendationInfo {
  String profilePic;
  String movieName;
  String recBy;

  RecommendationInfo({
    this.profilePic = "asserts/AvengersPoster.jpg",
    this.movieName = "AVENGERS ENDGAME",
    this.recBy = "Mike George",
  });
}
