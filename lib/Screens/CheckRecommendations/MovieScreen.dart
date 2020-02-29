import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template/CustomView/comment_view.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Screens/CheckRecommendations/MovieListZoomIn.dart';
import 'package:http/http.dart' as http;

import 'RecommendMovie.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<String> directors = [];
  List<String> actors = [];
  List<String> genres = [];
  String synopsis;
  int rating;
  MovieScreenArguments args;
  bool dataRetrieved = false;
  String name;

  @override
  void initState() {
    super.initState();
    name = "Loading...";
    directors = ["Anthony Russo", "Joe Russo"];
    actors = ["RDJ", "Chris Evans", "Chris Hemsworth", "Chris Prat"];
    genres = ["Action", "Drama", "Romantic"];
    synopsis = "Avengers: Endgame picks up after the events "
        "of Avengers: Infinity War, which saw the Avengers "
        "divided and defeated. Thanos won the day and used "
        "the Infinity Stones to snap away half of all life "
        "in the universe. Only the original Avengers - "
        "Iron Man, Captain America, Thor, Hulk, Black Widow, "
        "and Hawkeye remain, along with some key allies like "
        "War Machine, Ant-Man, Rocket Raccoon, Nebula, and "
        "Captain Marvel. Each of the survivors deals with the "
        "fallout from Thanos' decimation in different ways, but "
        "when an opportunity presents itself to potentially save "
        "those who vanished, they all come together and set out to "
        "defeat Thanos, once and for all.";
    rating = 5;
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    if (dataRetrieved != true && args != null)
      getMovieDetails(args.id);

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.blue[900],
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(name),
              background: _getMoviePicture(context),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Movie Details",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                _getMovieInfo(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Friend Ratings",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                _getFriendRatings(),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 8, 5),
                  child: InkWell(
                    onTap: (){},
                    child: Text(
                      "Load More",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SelectOption();
          }));
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget _getMoviePicture(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asserts/no_picture.jpg"),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _stars(4),
        ),
      ],
    );
  }

  Widget _getMovieInfo(context) {
    String directorString = _getStringsFromList(directors);
    String actorsString = _getStringsFromList(actors, limit: 24);
    String genreString = _getStringsFromList(genres);
    return Column(
      children: <Widget>[
        _movieInfoContent("Genre", genreString, onPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MovieListZoomIn(
              movieName: "Avengers",
              list: genres,
            );
          }));
        }),
        _movieInfoContent("Directors", directorString, onPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MovieListZoomIn(
              movieName: "Avengers",
              list: directors,
            );
          }));
        }),
        _movieInfoContent(
          "Actors",
          actorsString,
          onPress: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MovieListZoomIn(
                movieName: "Avengers",
                list: actors,
              );
            }));
          },
        ),
        _movieInfoContent(
          "Synopsis",
          _getShorterText(synopsis),
          onPress: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MovieListZoomIn(
                movieName: "Avengers",
                list: [synopsis],
              );
            }));
          },
        ),
      ],
    );
  }

  Widget _movieInfoContent(String title, String subtitle, {Function onPress}) {
    return Card(
      child: ListTile(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$title: ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: subtitle,
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          if (onPress != null) onPress();
        },
      ),
    );
  }

  Widget _stars(double rating) {
    return SmoothStarRating(
      starCount: 5,
      rating: rating,
      color: Colors.green,
      borderColor: Colors.green,
    );
  }

  String _getShorterText(String text) {
    String toReturn = text;
    if (text.length >= 18) {
      toReturn = toReturn.substring(0, 18);
      toReturn += " ...";
    }
    return toReturn;
  }

  String _getStringsFromList(List<String> list, {int limit}) {
    String toReturn = "";
    limit = limit ?? 20;
    for (int i = 0; i < list.length; i++) {
      toReturn += list[i];
      if (toReturn.length > limit) {
        toReturn = toReturn.substring(0, limit) + " ...";
        break;
      }
      toReturn += ", ";
    }
    return toReturn;
  }

  Widget _getFriendRatings() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CommentView(
            rating: 4,
            image: "asserts/no_picture_avatar.jpg",
            name: "Josh Radnor",
            text: "I enjoyed this movie but was a bit dull at times",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CommentView(
            rating: 4,
            image: "asserts/no_picture_avatar.jpg",
            name: "Josh Radnor",
            text: "I enjoyed this movie but was a bit dull at times",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CommentView(
            rating: 4,
            image: "asserts/no_picture_avatar.jpg",
            name: "Josh Radnor",
            text: "I enjoyed this movie but was a bit dull at times",
          ),
        ),
      ],
    );
  }

  void getMovieDetails(String id) async{
    args = ModalRoute.of(context).settings.arguments;
    dynamic response = await http.post("http://www.omdbapi.com/?i=$id&apikey=80246e40");
    var data = json.decode(response.body);
    actors = data["Actors"].split(",");
    directors = data["Director"].split(",");
    genres = data["Genre"].split(",");
    synopsis = data["Plot"];
    name = data["Title"];
    print(actors[0]);
    dataRetrieved = true;
    setState(() {});
  }
}

class SelectOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Options"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Recommend Movie"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return RecommendMovie();
              }));
            },
          ),
          fullDivider(),
          ListTile(
            title: Text("Add to Watch List"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          fullDivider(),
          ListTile(
            title: Text("Review"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget fullDivider() {
    return Divider(
      color: Colors.black,
    );
  }
}
