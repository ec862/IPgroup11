import 'package:flutter/material.dart';
import 'profile.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class OtherProfile extends StatefulWidget {
  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {

  int currentindex = 0; // home = 0
  bool pressed = true;
  String strText = 'Follow';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Jeffs Profile'),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),

        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(''),
            ),*/
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1501549538842-2f24e2dd6520?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Jeff Davis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                ButtonTheme(
                  minWidth: 120.0,
                  height: 50.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.blue)
                    ),
                    color: pressed
                      ? Colors.white
                      : Colors.blue,
                    textColor: pressed
                      ? Colors.black
                      : Colors.white,
                    child: new Text(strText),
                    onPressed: () {
                      setState(() {
                        //strText = 'unfollow';
                        if (pressed == true){
                          strText = 'Unfollow';
                        } else {
                          strText = 'Follow';
                        }
                        pressed = !pressed;
                      });
                    },
                  ),
                ),

                /*ButtonTheme(
                  minWidth: 120.0,
                  height: 50.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text(strText),
                      onPressed: () {
                        setState(() {
                          pressed = !pressed;
                        });
                      },
                    ),
                ),*/

                ButtonTheme(
                  minWidth: 120.0,
                  height: 50.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue)),
                    onPressed: () {},
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text("Watch List",
                        style: TextStyle(fontSize: 16)),
                  ),
                ),

                ButtonTheme(
                  minWidth: 120.0,
                  height: 50.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue)),
                    onPressed: () {},
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text("Review list",
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Favorite Movie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('Joker', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Favorite Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('Thriller', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Followers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('22', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Friends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('10', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Reviewed movies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('30', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Category most watched', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('Action', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Gender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('Male', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Date of birth', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                ),
                Container(
                  width: 120,
                  child: Text('08/09/2000', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),

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