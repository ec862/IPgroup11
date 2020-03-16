import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template/CustomView/comment_view.dart';
import 'package:template/Models/Arguments.dart';
import 'package:http/http.dart' as http;
import 'package:template/Models/User.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Screens/CheckRecommendations/ReviewScreen.dart';
import 'package:template/Models/User.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';
import 'dart:math';
import 'RecommendMovie.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class MovieScreen extends StatefulWidget {
  MovieScreen({Key key}):super(key: key);

  @override
  createState() => new _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<String> directors = [];
  List<String> actors = [];
  List<String> genres = [];
  String synopsis;
  double rating;
  MovieScreenArguments args;
  bool dataRetrieved = false;
  String name;
  String profileUrl;

  @override
  void initState() {
    super.initState();
    name = "Loading...";
    directors = [""];
    actors = [""];
    genres = [""];
    synopsis = "";
    profileUrl = "waiting..";
    rating = 5;
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    if (dataRetrieved != true && args != null) getMovieDetails(args.id);

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.blue[900],
            expandedHeight: 300,
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
                    onTap: () {},
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
            return SelectOption(
              movieID: args.id,
              name: name,
            );
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
        Hero(
          tag: "poster",
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (a, b, c) {
                    return ProfileFullScreen(profileUrl);
                  },
                  transitionDuration: Duration(milliseconds: 200)));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageServices.moviePoster(profileUrl),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _stars(rating),
        ),
      ],
    );
  }

  Widget _getMovieInfo(context) {
    String directorString = _getStringsFromList(directors, limit: 20);
    String actorsString = _getStringsFromList(actors, limit: 24);
    String genreString = _getStringsFromList(genres, limit: 24);
    return Column(
      children: <Widget>[
        MovieInfoContent(
          title: "Genre",
          shortTitle: genreString,
          fullTitle: _getStringsFromList(genres),
        ),
        MovieInfoContent(
          title: "Directors",
          shortTitle: directorString,
          fullTitle: _getStringsFromList(directors),
        ),
        MovieInfoContent(
          title: "Actors",
          shortTitle: actorsString,
          fullTitle: _getStringsFromList(actors),
        ),
        MovieInfoContent(
          title: "Synopsis",
          shortTitle: _getShorterText(synopsis),
          fullTitle: synopsis,
        ),
      ],
    );
  }

  Widget _stars(double rating) {
    return SmoothStarRating(
      starCount: 5,
      rating: rating,
      color: Colors.yellow[600],
      borderColor: Colors.yellow[600],
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
    if (limit == null) {
      for (int i = 0; i < list.length; i++) {
        toReturn += list[i];
        if (i < list.length - 1) toReturn += " ";
      }
      return toReturn;
    }

    for (int i = 0; i < list.length; i++) {
      toReturn += list[i];
      if (toReturn.length > limit) {
        toReturn = toReturn.substring(0, limit) + " ...";
        break;
      }
      toReturn += " ";
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

  void getMovieDetails(String id) async {
    args = ModalRoute.of(context).settings.arguments;
    dynamic response =
    await http.post("http://www.omdbapi.com/?i=$id&apikey=80246e40");
    var data = json.decode(response.body);
    actors = data["Actors"].split(",");
    directors = data["Director"].split(",");
    genres = data["Genre"].split(",");
    synopsis = data["Plot"];
    name = data["Title"];
    profileUrl = data["Poster"];
    rating = double.parse(data["imdbRating"]);
    rating = rating / 2;
    print(rating);
    print(actors[0]);
    dataRetrieved = true;
    setState(() {});
  }


}

class SelectOption extends StatelessWidget {
  String name = "";
  String movieID = "";

  SelectOption({@required this.movieID, @required this.name});

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
                return RecommendMovie(movieID: movieID, movieName: name,);
              }));
            },
          ),
          fullDivider(),
          ListTile(
            title: Text("Add to Watch List"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              await DatabaseServices(User.userdata.uid)
                  .addToWatchList(movieID: movieID, movieName: name);
              Fluttertoast.showToast(
                msg: "Movie added",
                gravity: ToastGravity.CENTER,
              );
              Navigator.of(context).pop();
            },
          ),
          fullDivider(),
          ListTile(
            title: Text("Rate and Review"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return ReviewScreen();
              }));
            },
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

class ProfileFullScreen extends StatelessWidget {
  final posterUrl;

  ProfileFullScreen(this.posterUrl,{Key key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
          tag: "poster",
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageServices.moviePoster(posterUrl),
                  fit: BoxFit.fitWidth,
                )),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class MovieInfoContent extends StatefulWidget {
  String title;
  String fullTitle;
  String shortTitle;
  Function onPress;

  MovieInfoContent(
      {@required this.title,
        @required this.shortTitle,
        @required this.fullTitle});

  @override
  _MovieInfoContentState createState() => _MovieInfoContentState();
}

class _MovieInfoContentState extends State<MovieInfoContent>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  AnimationController _animationController;
  Animation _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween(begin: 0.0, end: pi).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                "${expanded ? "${widget.title}:\n" : "${widget.title}:\n"}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "${expanded ? widget.fullTitle : widget.shortTitle}",
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic, //Ask group
                ),
              ),
            ],
          ),
        ),
        trailing: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _arrowAnimation.value,
              child: Icon(Icons.keyboard_arrow_up),
            );
          },
        ),
        onTap: () {
          setState(() {
            expanded = !expanded;
            expanded
                ? _animationController.forward()
                : _animationController.reverse();
          });
        },
      ),
    );
  }
}