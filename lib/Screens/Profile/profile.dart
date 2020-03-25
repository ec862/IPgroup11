import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Screens/main.dart';
import 'package:template/Services/AuthenticationServices.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'editProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:flutter/scheduler.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    Future<List<FollowerDetails>> following = DatabaseServices(User.userdata.uid).getFollowing();
    Future<List<FollowerDetails>> followers = DatabaseServices(User.userdata.uid).getFollowers();
    Future<List<ReviewDetails>> reviewlist = DatabaseServices(User.userdata.uid).getReviewList();

    String _getMostCommon(List<String> array){
      if(array.length == 0)
        return null;
      var modeMap = {};
      var maxEl = array[0], maxCount = 1;
      for(var i = 0; i < array.length; i++)
      {
        var el = array[i];
        if(modeMap[el] == null)
          modeMap[el] = 1;
        else
          modeMap[el]++;
        if(modeMap[el] > maxCount)
        {
          maxEl = el;
          maxCount = modeMap[el];
        }
      }
      return maxEl;
    }

    Future<String> _getMostWatched(List<String> movie_ids) async{
       Future<List<MovieDetails>> tempList = Future.wait(movie_ids.map(
              (id) async =>
              await DatabaseServices(User.userdata.uid).getMovieDetails(id: id))
          .toList());
       List<MovieDetails> movieList = await tempList;
       List<List<String>> genresList = movieList.map((movie) => (movie.genres)).toList();
       List<String> flatList = genresList.expand((i) => i).toList();
       return _getMostCommon(flatList);
    }

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 110,
                    height: 140,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1501549538842-2f24e2dd6520?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'),
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
              Column(
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
              Row(
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
                      child:  Center(
                        child: FutureBuilder(future: followers,
                            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                            }),
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
                      child:  Center(
                        child: FutureBuilder(future: following,
                            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                              if (!snapshot.hasData)
                                return Text(
                                  "Following \n0}",
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
              Row(
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
                      showDialog(context: context, child:
                      new AlertDialog(
                        content: new Text(details.favorite_movie),
                      )
                      );
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

                  /*Container(
                    width: 120,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      text: details.favorite_movie),
                    ),
                  ),*/
                    /*child: Text(details.favorite_movie,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ),*/



                  /*Container(
                    width: 120,
                    child: Text(details.favorite_movie,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),*/
                ],
              ),
              Row(
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
                    child: Text(details.favorite_category,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Followers',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600])),
                  ),
                  Container(
                    width: 120,
                    child: FutureBuilder(future: followers,
                        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData)
                            return Text('0',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold));
                          List<FollowerDetails> content = snapshot.data;
                          return Text('${content.length}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold));
                        }),
                  ),
                ],
              ),
              Row(
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
                    child: FutureBuilder(future: DatabaseServices(User.userdata.uid).getFriends(),
                        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData)
                            return Text('0',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold));
                          List<FollowerDetails> content = snapshot.data;
                          return Text('${content.length}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold));
                        }),
                  ),
                ],
              ),
              Row(
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
                    child: FutureBuilder(future: reviewlist,
                        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                        }),
                  ),
                ],
              ),
              Row(
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
                    child: FutureBuilder(future: reviewlist,
                        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData)
                            return Text(
                              'Waiting',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          List<ReviewDetails> content = snapshot.data;
                          List<String> movieList = content.map((review) => (review.movie_id)).toList();
                          return FutureBuilder(future: _getMostWatched(movieList),
                            builder: (BuildContext context, AsyncSnapshot<String> mostWatched){
                              if (!mostWatched.hasData)
                                return Text(
                                  'Waiting',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              return Text(
                                '${mostWatched.data}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
              Row(
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
              Row(
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
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Authentication().signOut();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return AuthScreen();
                  }));
                },
                child:

                Container(
                  width: 180,
                child: ButtonTheme(

                  height:40,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.black)
                    ),
                    color: Colors.white,
                    disabledColor: Colors.blue[900],
                    child: Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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


  String getTimeText(Timestamp t){
    if (t == null) return '';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
