import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/Home/recommendByGenre.dart';
import 'package:template/Screens/Profile/editProfile.dart';
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
    getRecommendedMovies();
  }

  Future getRecommendedMovies() async {
    movies = await DatabaseServices(userID).getRecommendations();
    return movies;
  }

  Future getFaveGenre() async {
    return await DatabaseServices(userID).getUserInfo();
  }

  Future getFaveRecs(int numberOfMovies) async {
    UserDetails temp = await getFaveGenre();
    String favGenre = temp.favorite_category.toLowerCase();
    return await RecommendByGenre.getMovies(favGenre, numberOfMovies);
  }

  @override
  Widget build(BuildContext context) {
    final double headPadding = MediaQuery.of(context).size.height / 100;

    return User.userdata.firstLogIn
        ? EditProfile(
            text: 'Thriller',
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(52.0), // here the desired height
              child: AppBar(
                backgroundColor: Colors.blue[900],
                title: Text('Home Page'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/chats');
                    },
                  )
                ],
              ),
            ),
            body: createHomePage(headPadding),
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
        createSubtitle("Recent Recommendations"),
        Divider(
          height: 1,
        ),
        createRecentRecs(10),
        Divider(
          height: 1,
        ),
        createSubtitle("Fav. Genre Recommendations"),
        Divider(
          height: 1,
        ),
        createRecsOnFav(10),
      ],
    );
  }

  Widget createSubtitle(String subtitle) {
    return Container(
      child: Text(
        subtitle,
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget createRecentRecs(int numberOfMovies) {
    return Container(
      height: (movies != null && movies.length > 0)
          ? MediaQuery.of(context).size.height * 0.73
          : 1,
      //width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        builder: (context, projectSnap) {
          return createScrollRecs(numberOfMovies, true, projectSnap);
        },
        future: getRecommendedMovies(),
      ),
    );
  }

  Widget createRecsOnFav(int numberOfMovies) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.73,
      child: FutureBuilder(
        builder: (context, projectSnap) {
          return createScrollRecs(numberOfMovies, false, projectSnap);
        },
        future: getFaveRecs(numberOfMovies),
      ),
    );
  }

  Widget createScrollRecs(
      int numberOfMovies, bool recentRecs, var projectSnap) {
    if (projectSnap.connectionState != ConnectionState.done) {
      return Center(
        child: Text("Loading..."),
      );
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemCount: ((projectSnap.data != null)
            ? (projectSnap.data.length > numberOfMovies
                ? numberOfMovies
                : projectSnap.data.length)
            : 0),
        itemBuilder: (BuildContext context, int index) => Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                builder: (context, projectSnapInner) {
                  if (projectSnapInner.connectionState !=
                      ConnectionState.done) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return projectSnapInner.data;
                  }
                },
                future:
                    MovieContent(projectSnap.data[index]).cardBuilder(context),
              ),
            ),
            (recentRecs
                ? Positioned(
                    right: 10,
                    top: 11,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        color: Colors.blueAccent,
                        splashColor: Colors.red,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          print(movies[index].rec_by);
                          if (recentRecs) {
                            setState(() {
                              DatabaseServices(User.userdata.uid)
                                  .removeRecommendation(
                                movieID: movies[index].movie_id,
                                recFrom: movies[index].rec_by,
                              );
                              movies.removeAt(index);
                            });
                          } else {
                            setState(() {
                              RecommendByGenre.action
                                  .remove(movies[index].movie_id);
                            });
                          }
                        },
                      ),
                    ),
                  )
                : SizedBox()),
          ],
        ),
      );
    }
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
