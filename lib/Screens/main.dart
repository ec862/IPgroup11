import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/Screens/Chats/chat_messages.dart';
import 'package:template/Screens/Chats/chats.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/CheckRecommendations/MovieScreen.dart';
import 'package:template/Screens/Home/homepage.dart';
import 'package:template/Screens/Profile/followers.dart';
import 'package:template/Screens/Profile/otherProfile.dart';
import 'package:template/Screens/Profile/profile.dart';
import 'package:template/Screens/WatchList/watchlist.dart';
import 'package:template/loginScreen2.dart';

import 'CheckRecommendations/ReviewScreen.dart';
import 'CheckRecommendations/SeeReviewScreen.dart';

void main() => runApp(AuthScreen());

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final FirebaseMessaging _fbm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fbm.configure(
      onMessage: (Map<String, dynamic> message) async {
        Fluttertoast.showToast(msg: "$message");
        print(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        Fluttertoast.showToast(msg: "$message");
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        Fluttertoast.showToast(msg: "$message");
        print(message);
      },
    );
  }

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
                case '/otherProfile':
                  return new OtherProfile();
                case '/chats':
                  return new Chats();
                case '/chatMessages':
                  return new ChatMessages();
                case '/chatMessages':
                  return new ChatMessages();
                case '/reviewscreen':
                  return new ReviewScreen(movieID: null);
                case '/seereview':
                  return new SeeReviewScreen();

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
                case '/chats':
                  return effectMap[PageTransitionType.slideUp](
                      Curves.linear, animation, secondaryAnimation, child);
                case '/chatMessages':
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
