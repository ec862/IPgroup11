import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'package:template/Screens/WatchList/watchlist.dart';
import 'package:template/Services/ImageServices.dart';
import 'package:template/Models/Arguments.dart';

class WatchCard extends StatefulWidget {
  final bool isUser;
  final String movieID;
  final bool isReview;
  final double rating;

  WatchCard(
      {this.isUser,
      @required this.movieID,
      @required this.isReview,
      this.rating});

  @override
  _WatchCardState createState() => _WatchCardState();
}

class _WatchCardState extends State<WatchCard> {
  String title = "Waiting...";
  String genre = "Waiting...";
  String date = "Waiting...";
  String movieRating = 'Not Rated';
  String img;
  bool dataRetrieved = false;

  String _getShorterText(String text, int maxLen) {
    String toReturn = text;
    if (text.length >= maxLen) {
      toReturn = toReturn.substring(0, maxLen);
      toReturn += " ...";
    }
    return toReturn;
  }

  void getMovieDetails(String id) async {
    dynamic response =
        await http.post("http://www.omdbapi.com/?i=$id&apikey=80246e40");
    var data = json.decode(response.body);
    title = _getShorterText(data["Title"],18);
    img = data["Poster"];
    genre = data["Genre"].split(",").toString();
    genre = _getShorterText(genre.substring(1, genre.length - 1),26);
    movieRating = data['Rated'];
    dataRetrieved = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (dataRetrieved != true) getMovieDetails(widget.movieID);
    return GestureDetector(
      onTap: widget.isReview
          ? () {
              Navigator.pushNamed(
                context,
                '/seereview',
                arguments: MovieScreenArguments(id: widget.movieID),
              );
            }
          : () {
              Navigator.pushNamed(
                context,
                '/moviepage',
                arguments: MovieScreenArguments(id: widget.movieID),
              );
            },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // --- Movie Poster ---
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageServices.moviePoster(img),
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          // --- Title Text ---
                          "${_getShorterText(title, 18)}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.grey[600]),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          // --- Genre Text ---
                          genre,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        widget.isReview
                            ? SmoothStarRating(
                                // --- Star Rating ---
                                allowHalfRating: false,
                                onRatingChanged: (v) {},
                                starCount: 5,
                                rating: widget.rating,
                                size: 30.0,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                color: Colors.yellow,
                                borderColor: Colors.yellow,
                                spacing: 0.0)
                            : Text(""),
                      ]),
                ],
              ),
              SizedBox(width: 4.0,),
              widget.isUser ? IconButton(
            onPressed: widget.isReview
                ? () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectOptions(
                  widget.movieID,
                  isReview: true,
                  movieName: title,
                  movieRating: movieRating,
                );
              }));
            }
                : () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectOptions(
                  widget.movieID,
                  isReview: false,
                  movieName: title,
                  movieRating: movieRating,
                );
              }));
            },
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
          ): Container(),
            ],
          ),
        ),
      ),
    );
  }
}
