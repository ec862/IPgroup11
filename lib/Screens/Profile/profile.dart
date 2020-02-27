import 'package:flutter/material.dart';
import 'editProfile.dart';
import 'otherProfile.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  int currentindex = 0; // home = 0

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile()),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile()),
                );
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width:110,
                  height:140,
                ),
                /*Container(
                  color: Colors.red,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(''),
                  ),
                ),*/
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1501549538842-2f24e2dd6520?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'),
                ),
                Container(
                  width:110,
                  height:140,
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: (){
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile()),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                  ),
                ),

                /*Container(
                  width: 50,
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                    elevation: 0,
                    onPressed: () => {},
                    tooltip: 'Edit',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Text("Edit"),
                      ],
                    ),
                    //label: Text('Approve'),
                  ),
                ),*/
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Frank Davis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  child: Row(
                    children: <Widget>[
                      Text('10', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      //Align

                      SizedBox(
                            height: 22.0,
                            width: 22.0,
                            child: new IconButton(
                              padding: new EdgeInsets.all(0.0),
                              icon: new Icon(Icons.arrow_forward_ios, size: 16.0),
                              onPressed: (){},
                            ),
                        ),
                    ],
                  ),
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