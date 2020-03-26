import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Screens/main.dart';
import 'package:template/Services/AuthenticationServices.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';
import 'editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/Models/UserDetails.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String userName = '';
  String favoriteMovie = '';
  String favoriteCategory = '';
  String friends = "0";

  String reviewedMovies = "30";
  String catMostWatched = "";
  String gender = "Male";
  String dob = "08/09/2000";

  UserDetails userDetails;

  Future getCurrentUser() async {
    FirebaseUser user = await Authentication().user;
    if (user == null) return;
    DatabaseServices dbs = await DatabaseServices(user.uid);
    userDetails = await DatabaseServices(User.userdata.uid).getUserInfo();
    name = userDetails.name ?? '';
    userName = userDetails.user_name ?? '';
    favoriteMovie = userDetails.favorite_movie ?? '';
    favoriteCategory = userDetails.favorite_category ?? '';
    setState(() => name = userDetails.name ?? '');
  }

  void initState() {
    super.initState();
    setState(() {
      getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List<FollowerDetails>> following =
        DatabaseServices(User.userdata.uid).getFollowing();
    Future<List<FollowerDetails>> followers =
        DatabaseServices(User.userdata.uid).getFollowers();
    Future<List<ReviewDetails>> reviewlist =
        DatabaseServices(User.userdata.uid).getReviewList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              Navigator.of(context).pushNamed('/chats');
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: DatabaseServices(User.userdata.uid).userStream,
        builder: (context, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          UserDetails details = snap.data;
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 110,
                      height: 140,
                    ),
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: ImageServices.profileImage(details.photo_profile),
                    ),
                    Container(
                      width: 40,
                      //width: 110,
                    ),
                    Container(
                        height: 140,
                        alignment: Alignment.topRight,
                        child: SizedBox.fromSize(
                          size: Size(56, 56), // button width and height
                          child: ClipOval(
                            child: Material(
                              color: Colors.white, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // splash color
                                onTap: () {
                                  //print(name);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        text: 'Thriller',
                                      ),
                                    ),
                                  );
                                },
                                // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.edit), // icon
                                    Text("Edit"), // text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      // Align however you like (i.e .centerRight, centerLeft)
                      child: Text(details.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('#${details.user_name}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    ButtonTheme(
                      minWidth: 120.0,
                      height: 50.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.blue)),
                        color: Colors.white,
                        child: Center(
                          child: FutureBuilder(
                            future: followers,
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              if (!snapshot.hasData)
                                return Text(
                                  "Followers \n0}",
                                  textAlign: TextAlign.center,
                                );

                              List<FollowerDetails> content = snapshot.data;
                              return Text(
                                "Followers \n${content.length}",
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/followers');
                        },
                      ),
                    ),
                    Spacer(),
                    ButtonTheme(
                      minWidth: 120.0,
                      height: 50.0,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.blue)),
                        color: Colors.white,
                        child: Center(
                          child: FutureBuilder(
                              future: following,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List> snapshot) {
                                if (!snapshot.hasData)
                                  return Text(
                                    "Following \n0",
                                    textAlign: TextAlign.center,
                                  );

                                List<FollowerDetails> content = snapshot.data;
                                return Text(
                                  "Following \n${content.length}",
                                  textAlign: TextAlign.center,
                                );
                              }),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/followings');
                        },
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Favorite Movie',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            child: new AlertDialog(
                              content: new Text(details.favorite_movie),
                            ));
                      },
                      child: Container(
                        width: 105,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: details.favorite_movie),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Favorite Category',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    Container(
                      width: 120,
                      child: Text(
                        details.favorite_category,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Friends',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    Container(
                      width: 120,
                      child: Row(
                        children: <Widget>[
                          Text(friends,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Reviewed movies',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    Container(
                      width: 120,
                      child: FutureBuilder(
                        future: reviewlist,
                        builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData)
                            return Text(
                              '0',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          List<ReviewDetails> content = snapshot.data;
                          return Text(
                            '${content.length}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Category most watched',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      child: Text(catMostWatched,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Gender',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    Container(
                      width: 120,
                      child: Text(details.gender,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Date of birth',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      child: Text(
                        '${getTimeText(details.dob)}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(75,8, 75, 8),
                child: ButtonTheme(
                  height: 50.0,
                  minWidth: 100.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                    color: Colors.white,
                    child: Center(child: Text('Logout')),
                    onPressed: () {
                      Authentication().signOut();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) {
                        return AuthScreen();
                      }));
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomBar().createBar(context, 4),
      //bottomNavigationBar: BottomBar().createBar(context, 4),
    );
  }

  String getTimeText(Timestamp t) {
    if (t == null) return '';
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
