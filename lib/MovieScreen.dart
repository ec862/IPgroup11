import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/MovieListZoomIn.dart';
import 'package:template/RecommendMovie.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  String genre;
  List<String> directors = [];
  List<String> actors = [];
  List<String> genres = [];
  String synopsis;
  int rating;

  @override
  void initState() {
    super.initState();
    genre = "Avengers";
    directors = ["Anthony Russo", "Joe Russo"];
    actors = ["RDJ", "Chris Evans", "Chris Hemsworth", "Chris Prat"];
    genres = ["Action", "Drama", "Romantic"];
    synopsis = "Thanos the mad titan";
    rating = 5;
  }

  int currentindex = 0; // home = 0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Page Name'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //TODO
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),

      body: ListView(
        children: <Widget>[
          getMoviePicture(context),
          getMovieInfo(context),
        ],
      ), //TODO

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
        selectedFontSize: 0.0,
        backgroundColor: BOTTOM_BAR_COLOR,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: currentindex,
        onTap: (index) {
          setState(() {
            currentindex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: BOTTOM_BAR_COLOR,
              title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              backgroundColor: BOTTOM_BAR_COLOR,
              title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              backgroundColor: BOTTOM_BAR_COLOR,
              title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              backgroundColor: BOTTOM_BAR_COLOR,
              title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: BOTTOM_BAR_COLOR,
              title: Text('')),
        ],
      ),
    );
  }

  Widget getMoviePicture(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asserts/no_picture.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SelectOption();
              }));
            },
            padding: EdgeInsets.all(0),
            iconSize: 70,
            icon: Icon(
              Icons.brightness_1,
              color: Colors.pinkAccent,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Icon(
            Icons.arrow_forward,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getMovieInfo(context) {
    String directorString = getStringsFromList(directors);
    String actorsString = getStringsFromList(actors, limit: 24);
    String genreString = getStringsFromList(genres);
    return Column(
      children: <Widget>[
        movieInfoContent("Genre", genreString, onPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MovieListZoomIn(
              movieName: "Avengers",
              list: genres,
            );
          }));
        }),
        fullDivider(),
        movieInfoContent("Directors", directorString, onPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MovieListZoomIn(
              movieName: "Avengers",
              list: directors,
            );
          }));
        }),
        fullDivider(),
        movieInfoContent("Actors", actorsString, onPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MovieListZoomIn(
              movieName: "Avengers",
              list: actors,
            );
          }));
        }),
        fullDivider(),
        movieInfoContent("Synopsis", synopsis, onPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MovieListZoomIn(
              movieName: "Avengers",
              list: [synopsis],
            );
          }));
        }),
        fullDivider(),
        stars(4),
      ],
    );
  }

  Widget movieInfoContent(String title, String subtitle, {Function onPress}) {
    return ListTile(
      title: Text.rich(
        TextSpan(children: [
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
        ]),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        if (onPress != null) onPress();
      },
    );
  }

  Widget stars(int rating) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Icon(
            index > (rating - 1) ? Icons.star_border : Icons.star,
            size: 50,
            color: Colors.amberAccent,
          );
        },
        itemCount: 5,
      ),
    );
  }

  Widget fullDivider() {
    return Divider(
      color: Colors.black,
    );
  }

  String getShorterText(String text) {
    String toReturn = text;
    if (text.length >= 18) {
      toReturn.substring(0, 18);
      toReturn += "...";
    }
    return toReturn;
  }

  String getStringsFromList(List<String> list, {int limit}) {
    String toReturn = "";
    limit = limit ?? 20;
    for (int i = 0; i < list.length; i++) {
      toReturn += list[i];
      if (toReturn.length > limit) {
        toReturn = toReturn.substring(0, limit) + "...";
        break;
      }
      toReturn += ", ";
    }
    return toReturn;
  }
}

class SelectOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
