import 'package:flutter/material.dart';
import 'package:template/Screens/CheckRecomendations.dart';
import 'package:template/Screens/MovieScreen.dart';
import 'package:template/Screens/followers.dart';
import 'package:template/Screens/homepage.dart';
import 'package:template/Screens/profile.dart';
import 'package:template/Screens/searchpage.dart';
import 'package:template/Screens/watchlist.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      initialRoute: Routes.bottomRoutes[0],
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        Routes.bottomRoutes[0]: (BuildContext context) => new Homepage(),
        Routes.bottomRoutes[1]: (BuildContext context) => new MovieSearchPage(),
        Routes.bottomRoutes[2]: (BuildContext context) => new CheckRecomendations(),
        Routes.bottomRoutes[3]: (BuildContext context) => new WatchList(),
        Routes.bottomRoutes[4]: (BuildContext context) => new Profile(),
        '/friendsearchpage': (BuildContext context) => new FriendSearchPage(),
        '/moviepage': (BuildContext context) => new MovieScreen(),
        '/followers': (BuildContext context) => new Followers(index: 0),
        '/followings': (BuildContext context) => new Followers(index: 1),
      },
    );
  }
}

class Routes {
  static final bottomRoutes = [
    '/',
    '/moviesearchpage',
    '/checkrecomendations',
    '/watchlist',
    '/profile'
  ];
}
