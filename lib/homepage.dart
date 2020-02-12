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
    final double headPadding = MediaQuery
        .of(context)
        .size
        .height / 28;
    final double listSize = MediaQuery
        .of(context)
        .size
        .height / 8.1;

    return Scaffold(
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
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.black26,
            padding: EdgeInsets.all(headPadding),
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  splashColor: Colors.deepOrangeAccent,
                  child: Container(
                      child: Text(
                        "Recommend New Movie",
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
                    child: Text("See All Friend Recomendations",
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8))),
              ],
            ),
          ),

          Divider(
            color: Colors.black,
            height: 15,
          ),

          Text("Recent Recomendations",
            style: TextStyle(fontSize: listSize / 3.4),),
          SizedBox(height: 1,),

          Expanded(
              child: Align(alignment: Alignment.topCenter,
                  child: new ListView.builder(itemBuilder: (
                      BuildContext context, int index) {
                    return new Container(height: listSize,
                        child: Card(child: ListTile(
                            leading: Icon(Icons.movie, size: listSize / 1.75,),
                            title: Text("hello$index",
                              style: TextStyle(fontSize: listSize / 3),),
                            subtitle: Text("Rec. by AAA BBB",
                                style: TextStyle(fontSize: listSize / 6.25)),
                            trailing: Container(child: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.lightGreenAccent,
                                shape: CircleBorder(),),
                              child: IconButton(icon: Icon(Icons.add),
                                color: Colors.black,
                                onPressed: () {
                                  print("here$index");
                                },
                                iconSize: listSize / 2.5,),),
                            ))));
                  }, itemCount: 4,)
              ))
        ],
      ),

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
    );
  }
}