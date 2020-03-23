import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';

import '../../CustomView/BottomBar.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class CheckRecomendations extends StatefulWidget {
  @override
  _CheckRecomendationsState createState() => _CheckRecomendationsState();
}

class _CheckRecomendationsState extends State<CheckRecomendations> {
  List<RecommendedMoviesDetails> movies;
  String userID;
  List movieCards;

  @override
  void initState() {
    super.initState();
    userID = User.userdata.uid;
  }

  Future getRecomendedMovies() async {
    movies = await DatabaseServices(userID).getRecommendations();
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Check Recommendations'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              Navigator.of(context).pushNamed('/chats');
            },
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState != ConnectionState.done) {
            return Center(
              child: Text("Loading"),
            );
          } else {
            return ListView.builder(
              shrinkWrap: false,
              physics: BouncingScrollPhysics(),
              itemCount: ((movies != null) ? movies.length : 0),
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState != ConnectionState.done) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.72,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return projectSnap.data;
                    }
                  },
                  future: MovieContent(movies[index]).cardBuilder(context),
                );
              },
            );
          }
        },
        future: getRecomendedMovies(),
      ),
      bottomNavigationBar: BottomBar().createBar(context, 2),
    );
  }
}

class MovieContent {
  RecommendedMoviesDetails info;

  MovieContent(this.info);

  Future<String> getURL(String movieID) async {
    MovieDetails posterURl =
        await DatabaseServices(User.userdata.uid).getMovieDetails(id: movieID);
    return posterURl.profileUrl;
  }

  @override
  Future cardBuilder(BuildContext context) async {
    var posterURL = await getURL(info.movie_id);
    var poster = ImageServices.moviePoster(posterURL);

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/moviepage',
            arguments: MovieScreenArguments(id: info.movie_id),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.61,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: poster,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    "${_getShorterText(info.movie_name)}",
                    style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.height / 30)),
                  ),
                  subtitle: FutureBuilder(
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState != ConnectionState.done) {
                        return Text(
                          "Rec. by: ",
                          style: TextStyle(fontSize: 30),
                        );
                      } else {
                        StringBuffer a = new StringBuffer("Rec. by: ");
                        a.write(projectSnap.data != null
                            ? (projectSnap.data['name'] ??
                                projectSnap.data['user_name'])
                            : 'Person no longer has account');
                        return Text(
                          a.toString(),
                          style: TextStyle(fontSize: 16),
                        );
                      }
                    },
                    future: DatabaseServices(User.userdata.uid)
                        .getFriendInfo(uid: info.rec_by),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShorterText(String text) {
    String toReturn = text;
    int maxLen = 26;
    if (text == null) return "";

    if (text.length >= maxLen) {
      toReturn = toReturn.substring(0, maxLen);
      toReturn += " ...";
    }
    return toReturn;
  }
}
