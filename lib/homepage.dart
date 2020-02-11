import 'package:flutter/material.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentindex = 0; // home = 0

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Home Page'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                //TODO
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),

        //*******START OF NON-TEMPLATE***************
        body: Container(
            child: Column(
          children: <Widget>[
            Container(
              color: Colors.black26,
              padding: const EdgeInsets.all(25),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    splashColor: Colors.deepOrangeAccent,
                    child: Container(
                        child: Text(
                      "Recommend movie",
                      style: TextStyle(fontSize: 25),
                    )),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      onPressed: () {},
                      splashColor: Colors.deepOrangeAccent,
                      child: Text("See all recomendations",
                          style: TextStyle(fontSize: 25)),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8))),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              height: 15,
            ),
            Container(
              color: Colors.amber,
              padding: const EdgeInsets.all(30),
            )
          ],
        )),
        // **********END OF NON-TEMPLATE************

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
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
