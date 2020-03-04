import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/CheckRecommendations/MovieScreen.dart';
import 'package:template/Screens/Home/homepage.dart';
import 'package:template/Screens/Profile/followers.dart';
import 'package:template/Screens/Profile/profile.dart';
import 'package:template/Screens/WatchList/watchlist.dart';
import 'package:template/Services/AuthenticationServices.dart';
import 'package:template/loginScreen2.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: Authentication().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context);
    if (user == null) return OpenAuthScreen();

    if (user.isEmailVerified) {
      return OpenMainApp();
    } else {
      Fluttertoast.showToast(
        msg: "Please verify your email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
      Authentication().signOut();
      return OpenAuthScreen();
    }
  }
}

class OpenAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}

class OpenMainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      initialRoute: Routes.bottomRoutes[0],
      onGenerateRoute: (RouteSettings routeSettings) {
        return new PageRouteBuilder<dynamic>(
            settings: routeSettings,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              switch (routeSettings.name) {
                case '/':
                  return new Homepage();
                case '/checkrecomendations':
                  return new CheckRecomendations();
                case '/watchlist':
                  return new WatchList();
                case '/profile':
                  return new Profile();
                case '/moviepage':
                  return new MovieScreen();
                case '/followers':
                  return new Followers(index: 0);
                case '/followings':
                  return new Followers(index: 1);
                default:
                  return null;
              }
            },
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              switch (routeSettings.name) {
                case '/followers':
                  return effectMap[PageTransitionType.slideUp](
                      Curves.linear, animation, secondaryAnimation, child);
                case '/followings':
                  return effectMap[PageTransitionType.slideUp](
                      Curves.linear, animation, secondaryAnimation, child);
                default:
                  return effectMap[PageTransitionType.fadeIn](
                      Curves.linear, animation, secondaryAnimation, child);
              }
            });
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
