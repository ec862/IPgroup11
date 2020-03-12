import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/SearchTab/searchpage.dart';
import 'package:template/Services/DatabaseServices.dart';
import '../main.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<RecommendedMoviesDetails> movies;
  String userID;

  @override
  void initState() {
    super.initState();
    userID = User.userdata.uid;
    getRecomendedMovies();
  }

  void getRecomendedMovies() async {
    movies = await DatabaseServices(userID).getRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    final double headPadding = MediaQuery
        .of(context)
        .size
        .height / 100;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Home Page'),
        ),
      ),

      //*******START OF NON-TEMPLATE***************
      body: createHomePage(headPadding),

      // **********END OF NON-TEMPLATE************

      bottomNavigationBar: BottomBar().createBar(context, 0),
    );
  }

  ListView createHomePage(double headPadding) {
    return ListView(
      children: <Widget>[
        topButtons(context, headPadding),
        Divider(
          height: 1,
        ),
        Container(
          child: Text(
            "Recent Recommendations",
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.73,
          //width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: ((movies != null) ? (movies.length > 5 ? 5 : movies
                .length) : 0),
            itemBuilder: (BuildContext context, int index) =>
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: FutureBuilder(
                        builder: (context, projectSnap) {
                          if (projectSnap.connectionState !=
                              ConnectionState.done) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else {
                            return projectSnap.data;
                          }
                        },
                        future: MovieContent(movies[index]).cardBuilder(
                            context),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 11,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          color: Colors.blueGrey,
                          splashColor: Colors.red,
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              movies.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }

  Widget topButtons(BuildContext context, double headPadding) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(headPadding),
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            splashColor: Colors.deepOrangeAccent,
            child: Container(
                child: Text(
                  "Recommend New Movie",
                  style: TextStyle(fontSize: 25),
                )),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5)),
          ),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.bottomRoutes[2],
                  ModalRoute.withName('/'),
                );
              },
              splashColor: Colors.deepOrangeAccent,
              child: Text(
                "See All Friend Recomendations",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5))),
        ],
      ),
    );
  }
}
