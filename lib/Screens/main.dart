import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/CheckRecommendations/MovieScreen.dart';
import 'package:template/Screens/Home/homepage.dart';
import 'package:template/Screens/Profile/followers.dart';
import 'package:template/Screens/Profile/profile.dart';
import 'package:template/Screens/WatchList/watchlist.dart';
import 'package:template/loginScreen2.dart';

void main() => runApp(Entry());

class Entry extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }

}

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
                case '/' : return new Homepage();
                case '/checkrecomendations': return new CheckRecomendations();
                case '/watchlist': return new WatchList();
                case '/profile': return new Profile();
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
    '/searchpage',
    '/checkrecomendations',
    '/watchlist',
    '/profile'
  ];
}

/*
routes: <String, WidgetBuilder>{
        Routes.bottomRoutes[0]: (BuildContext context) => new Homepage(),
        Routes.bottomRoutes[1]: (BuildContext context) => new SearchPage(),
        Routes.bottomRoutes[2]: (BuildContext context) => new CheckRecomendations(),
        Routes.bottomRoutes[3]: (BuildContext context) => new WatchList(),
        Routes.bottomRoutes[4]: (BuildContext context) => new Profile(),
        '/friendsearchpage': (BuildContext context) => new FriendSearchPage(),
        '/moviepage': (BuildContext context) => new MovieScreen(),
        '/followers': (BuildContext context) => new Followers(index: 0),
        '/followings': (BuildContext context) => new Followers(index: 1),
      }
 */
