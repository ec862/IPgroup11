import 'package:flutter/material.dart';
import 'package:template/homepage.dart';
import 'homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

