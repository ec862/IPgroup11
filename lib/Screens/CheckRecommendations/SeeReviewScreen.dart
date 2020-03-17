import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';
import 'package:template/Models/Arguments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:template/Models/User.dart';

class SeeReviewScreen extends StatefulWidget {

  final movieID;

  SeeReviewScreen({Key key, @required this.movieID}) : super(key: key);

  @override
  _SeeReviewScreenState createState() => _SeeReviewScreenState();
}

class _SeeReviewScreenState extends State<SeeReviewScreen> {
  String name;
  double rating;
  String profileUrl;
  String comment;
  MovieScreenArguments args;
  bool dataRetrieved = false;
  ReviewDetails details;

  @override
  void initState() {
    super.initState();
    name = "Loading...";
    profileUrl = "waiting..";
    comment = "";
    rating = 5;
  }

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context).settings.arguments;
    if (dataRetrieved != true && args != null) getMovieDetails(args.id);
    getSingleReview(args.id);

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
                    "Your Review",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ]
            )
          ),
//          SliverList(
//              delegate: SliverChildListDelegate(
//                  [
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: SmoothStarRating(
//                        allowHalfRating: true,
//                        starCount: 5,
//                        rating: rating,
//                        size: 40.0,
//                        filledIconData: Icons.star,
//                        halfFilledIconData: Icons.star_half,
//                        color: Colors.yellow[600],
//                        borderColor: Colors.yellow[600],
//                        spacing:0.0,
//                      ),
//                    ),
//                  ]
//              )
//          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),

                    child: Text(
                      comment
                    ),
                ),
              ]
            )
          ),
        ]
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

  Widget _stars(double rating) {
    return SmoothStarRating(
      starCount: 5,
      rating: rating,
      color: Colors.yellow[600],
      borderColor: Colors.yellow[600],
    );
  }

  void getSingleReview(String id) async {
    details = await DatabaseServices(User.userdata.uid).getSingleReview(movieID: id);
    rating = details.rating;
    comment = details.comment;
  }

  void getMovieDetails(String id) async {
    args = ModalRoute.of(context).settings.arguments;
    dynamic response =
    await http.post("http://www.omdbapi.com/?i=$id&apikey=80246e40");
    var data = json.decode(response.body);
    name = data["Title"];
    profileUrl = data["Poster"];
    dataRetrieved = true;
    setState(() {});
  }
}

class ProfileFullScreen extends StatelessWidget {
  final posterUrl;

  ProfileFullScreen(this.posterUrl);

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
