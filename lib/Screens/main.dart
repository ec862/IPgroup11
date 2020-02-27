import 'package:flutter/material.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/CheckRecommendations/MovieScreen.dart';
import 'package:template/Screens/Profile/followers.dart';
import 'package:template/Screens/Home/homepage.dart';
import 'package:template/Screens/Profile/profile.dart';
import 'package:template/Screens/SearchTab/searchpage.dart';
import 'package:template/Screens/WatchList/watchlist.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_page_transition/transition_effect.dart';
import 'package:flutter_page_transition/transition_tween.dart';

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
                case '/': return new Homepage();
                case '/moviesearchpage': return new MovieSearchPage();
                case '/checkrecomendations': return new CheckRecomendations();
                case '/watchlist': return new WatchList();
                case '/profile': return new Profile();
                case '/friendsearchpage': return new FriendSearchPage();
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
