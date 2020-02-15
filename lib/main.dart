import 'package:flutter/material.dart';
import 'package:template/friendsearchpage.dart';
import 'package:template/homepage.dart';
import 'package:template/moviesearchpage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => new Homepage(),
        '/friendsearchpage': (BuildContext context) => new FriendSearchPage(),
        '/moviesearchpage': (BuildContext context) => new MovieSearchPage(),
      },
    );
  }
}



