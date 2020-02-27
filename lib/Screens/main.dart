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
      onGenerateRoute: (RouteSettings routeSettings){
        return new PageRouteBuilder<dynamic>(
            settings: routeSettings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              switch (routeSettings.name){
                case Routes.bottomRoutes[0] : return new Homepage();
                case Routes.bottomRoutes[1]: return new MovieSearchPage();
                case Routes.bottomRoutes[2]: return new CheckRecomendations();
                case Routes.bottomRoutes[3]: return new WatchList();
                case Routes.bottomRoutes[4]: return new Profile();
                case '/moviepage': return new MovieScreen();
                case '/followers': return new Followers(index: 0);
                case '/followings': return new Followers(index: 1);
                default: return null;
              }
            },
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              switch (routeSettings.name){
                case '/followers':
                  return effectMap[PageTransitionType.slideUp](Curves.linear, animation, secondaryAnimation, child);
                case '/followings':
                  return effectMap[PageTransitionType.slideUp](Curves.linear, animation, secondaryAnimation, child);
                default:
                  return effectMap[PageTransitionType.fadeIn](Curves.linear, animation, secondaryAnimation, child);
              }
            }
        );
      },
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
    '/searchpage',
    '/checkrecomendations',
    '/watchlist',
    '/profile'
  ];
}
