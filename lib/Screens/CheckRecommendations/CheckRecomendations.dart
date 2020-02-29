import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/Models/Arguments.dart';
import 'package:http/http.dart' as http;
import 'package:template/Services/ImageServices.dart';

import '../../CustomView/BottomBar.dart';

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
    movies.add(RecommendationInfo());
    movies.add(RecommendationInfo(id: "tt3896198"));
    movies.add(RecommendationInfo(id: "tt5052448"));
    movies.add(RecommendationInfo(id: "tt0848228"));
    movies.add(RecommendationInfo(id: "tt0974015"));
    movies.add(RecommendationInfo(id: "tt0369610"));
    movies.add(RecommendationInfo(id: "tt4881806"));
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
          return MovieContent(movies[index]);
        },
      ),
      bottomNavigationBar: BottomBar().createBar(context, 2),
    );
  }
}

class MovieContent extends StatefulWidget {
  RecommendationInfo info;
  MovieContent(this.info);
  @override
  _MovieContentState createState() => _MovieContentState();
}

class _MovieContentState extends State<MovieContent> {
  bool dataRetrieved = false;

  @override
  Widget build(BuildContext context) {
    if (dataRetrieved != true)
      getMovieDetails(widget.info.id);
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(
            context,
            '/moviepage',
            arguments: MovieScreenArguments(id: widget.info.id),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageServices.moviePoster(widget.info.profilePic),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            ListTile(
              title: Text("${_getShorterText(widget.info.movieName)}"),
              subtitle: Text(
                "Recommended by: ${_getShorterText(widget.info.recBy)}"
                    .toUpperCase(),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }

  String _getShorterText(String text) {
    String toReturn = text;
    int maxLen = 45;
    if (text == null) return "";

    if (text.length >= maxLen) {
      toReturn = toReturn.substring(0, maxLen);
      toReturn += " ...";
    }
    return toReturn;
  }

  void getMovieDetails(String id) async{
    dynamic response = await http.post("http://www.omdbapi.com/?i=$id&apikey=80246e40");
    var data = json.decode(response.body);
    widget.info.movieName = data["Title"];
    widget.info.profilePic = data["Poster"];
    print(widget.info.profilePic);
    dataRetrieved = true;
    setState(() {});
  }
}

class RecommendationInfo {
  String profilePic;
  String movieName;
  String recBy;
  String id;

  RecommendationInfo(
      {this.profilePic = "Waiting...",
      this.movieName = "Waiting...",
      this.recBy = "Waiting...",
      this.id = "tt4154796"});
}
