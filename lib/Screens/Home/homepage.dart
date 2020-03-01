import 'package:flutter/material.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Screens/SearchTab/searchpage.dart';

import '../main.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final double headPadding = MediaQuery.of(context).size.height / 28;
    final double listSize = MediaQuery.of(context).size.height / 8.1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Home Page'),
      ),

      //*******START OF NON-TEMPLATE***************
      body: createHomePage(headPadding, listSize),

      // **********END OF NON-TEMPLATE************

      bottomNavigationBar: BottomBar().createBar(context, 0),
    );
  }

  Column createHomePage(double headPadding, double listSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(headPadding),
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  showSearch(
                    context: context, delegate: CustomSearchDelegate(),);
                },
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
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.bottomRoutes[2],
                      ModalRoute.withName('/'),
                    );
                  },
                  splashColor: Colors.deepOrangeAccent,
                  child: Text(
                    "See All Friend Recomendations",
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8))),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          height: 15,
        ),
        Text(
          "Recent Recomendations",
          style: TextStyle(fontSize: listSize / 3.4),
        ),
        SizedBox(
          height: 1,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  height: listSize,
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.movie,
                        size: listSize / 1.75,
                      ),
                      title: Text(
                        "Movie $index",
                        style: TextStyle(fontSize: listSize / 3),
                      ),
                      subtitle: Text("Rec. by AAA BBB",
                          style: TextStyle(fontSize: listSize / 6.25)),
                      trailing: Container(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.lightGreenAccent,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.black,
                            onPressed: () {
                              print("here$index");
                            },
                            iconSize: listSize / 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 4,
            ),
          ),
        )
      ],
    );
  }
}
