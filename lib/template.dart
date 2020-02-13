import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/MovieScreen.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class Template extends StatefulWidget {
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {

  int currentindex = 0; // home = 0

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Page Name'),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                //TODO
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),

        body: Container(), //TODO

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30.0,
          selectedFontSize: 0.0,
          backgroundColor: BOTTOM_BAR_COLOR,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          currentIndex: currentindex,
          onTap: (index){
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
      ),
    );
  }
}