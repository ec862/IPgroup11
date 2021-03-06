import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Screens/WatchList/watchlist.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class BlockedButton extends StatefulWidget {
  String id;

  BlockedButton({Key key, @required this.id}) : super(key: key);

  @override
  _BlockedButtonState createState() => _BlockedButtonState();
}

class _BlockedButtonState extends State<BlockedButton> {
  bool youBlocked;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasError &&
            projectSnap.hasData &&
            projectSnap.connectionState == ConnectionState.done) {
          if (youBlocked == null) {
            youBlocked = projectSnap.data;
          }
          return new RaisedButton(
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: new BorderRadius.circular(15.0)),
            onPressed: () {
              if (youBlocked == false) {
                DatabaseServices(User.userdata.uid)
                    .blockUser(theirUID: widget.id);
                setState(() {
                  youBlocked = !youBlocked;
                });
              } else {
                DatabaseServices(User.userdata.uid)
                    .unBlockUser(theirUID: widget.id);
                setState(() {
                  youBlocked = !youBlocked;
                });
              }
            },
            splashColor: Colors.redAccent,
            child: new Text(
              (youBlocked) ? "Unblock" : "Block",
              style: TextStyle(fontSize: 20),
            ),
          );
        } else {
          return SizedBox(
            width: 1,
          );
        }
      },
      future: DatabaseServices(User.userdata.uid)
          .checkYouBlocked(theirUID: widget.id),
    );
  }
}

class OtherProfile extends StatefulWidget {
  OtherProfile({Key key}) : super(key: key);

  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  FollowerDetails details;
  bool youBlocked;
  bool blockedBy;
  bool pressed = true;
  String strText = 'Follow';
  OtherProfileArgument args;
  bool dataRetrieved = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isFollowing = false;
  bool isPrivate = true;
  Future<List<FollowerDetails>> following;
  Future<List<FollowerDetails>> followers;
  Future<List<ReviewDetails>> reviewlist;

  Future getData() async {
    blockedBy = await DatabaseServices(User.userdata.uid)
        .checkBlockedBy(theirUID: args.id);
    isPrivate = await DatabaseServices(User.userdata.uid)
        .isPrivate(uid: args.id);

    details =
        await DatabaseServices(User.userdata.uid).getFollower(uid: args.id);

    if (blockedBy == null)
      blockedBy = false;
    print(blockedBy);
    isFollowing = false;

    if (details == null) {
      strText = 'Follow';
      pressed = true;
      return;
    }

    if (!details.accepted) {
      pressed = false;
      strText = 'Request Pending';
    } else {
      pressed = false;
      strText = 'Un-Follow';
      isFollowing = true;
    }
    dataRetrieved = true;
  }

  String getTimeText(Timestamp t) {
    if (t == null) return '';
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  String _getMostCommon(List<String> array) {
    if (array.length == 0) return null;
    var modeMap = {};
    var maxEl = array[0], maxCount = 1;
    for (var i = 0; i < array.length; i++) {
      var el = array[i];
      if (modeMap[el] == null)
        modeMap[el] = 1;
      else
        modeMap[el]++;
      if (modeMap[el] > maxCount) {
        maxEl = el;
        maxCount = modeMap[el];
      }
    }
    return maxEl;
  }

  Future<String> _getMostWatched(List<String> movie_ids) async {
    Future<List<MovieDetails>> tempList = Future.wait(movie_ids
        .map((id) async =>
            await DatabaseServices(args.id).getMovieDetails(id: id))
        .toList());
    List<MovieDetails> movieList = await tempList;
    List<List<String>> genresList =
        movieList.map((movie) => (movie.genres)).toList();
    List<String> flatList = genresList.expand((i) => i).toList();
    return _getMostCommon(flatList);
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;

    if (!dataRetrieved) getData();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(args.userName),
        actions: <Widget>[
          FutureBuilder(
            future: DatabaseServices(User.userdata.uid).isFriend(uid: args.id),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) return Text("");
              return snapshot.data
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/chatMessages',
                          arguments: ChatMessagesArgument(id: args.id),
                        );
                      },
                      icon: Icon(Icons.message),
                    )
                  : Text("");
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else if (projectSnap.hasError) {
            return Text("Error");
          } else {
            return (blockedBy == true)
                ? blockedContent()
                : (shouldShowDetails() ? normalContent() : privateContent());
          }
        },
      ),
    );
  }

  bool shouldShowDetails() {
    if (isFollowing) return true;

    if (isPrivate) return false;

    return true;
  }

  Widget blockedContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: DatabaseServices(User.userdata.uid)
                        .getFriendInfo(uid: args.id),
                    builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return CircleAvatar(
                        radius: 70,
                        backgroundImage: ImageServices.profileImage(
                            snapshot.data.photo_profile),
                      );
                    },
                  ),
                ],
              ),
              new Positioned(
                right: 10,
                top: 0,
                child: BlockedButton(id: args.id),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(args.userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Divider(color: Colors.black,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("You have been blocked by this user"),
        )
      ],
    );
  }

  Widget privateContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: DatabaseServices(User.userdata.uid)
                        .getFriendInfo(uid: args.id),
                    builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return CircleAvatar(
                        radius: 70,
                        backgroundImage: ImageServices.profileImage(
                            snapshot.data.photo_profile),
                      );
                    },
                  ),
                ],
              ),
              new Positioned(
                right: 10,
                top: 0,
                child: BlockedButton(id: args.id),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(args.userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
              Widget>[
            ButtonTheme(
              minWidth: 120.0,
              height: 50.0,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.blue)),
                color: pressed ? Colors.white : Colors.blue,
                textColor: pressed ? Colors.black : Colors.white,
                child: new Text(strText),
                onPressed: () async {
                  if (pressed == true) {
                    strText = 'Request Pending';
                    await DatabaseServices(User.userdata.uid).follow(args.id);
                  } else {
                    strText = 'Follow';
                    await DatabaseServices(User.userdata.uid).unFollow(args.id);
                  }
                  pressed = !pressed;
                  dataRetrieved = false;
                  setState(() {});
                },
              ),
            ),
            ButtonTheme(
              minWidth: 120.0,
              height: 50.0,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () async {
                  if (await DatabaseServices(User.userdata.uid)
                      .isFollowing(uid: args.id)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WatchList(
                          uid: args.id,
                          index: 0,
                        ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "You're not a follower/ person hasnt accepted you "
                            "therefore you "
                            "cannot view the watch list of the person",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_SHORT);
                  }
                },
                color: Colors.white,
                textColor: Colors.black,
                child: Text("Watch List", style: TextStyle(fontSize: 16)),
              ),
            ),
            ButtonTheme(
              minWidth: 120.0,
              height: 50.0,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () async {
                  if (await DatabaseServices(User.userdata.uid)
                      .isFollowing(uid: args.id)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WatchList(
                          uid: args.id,
                          index: 1,
                        ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "You're not a follower/ person hasnt accepted you "
                            "therefore you "
                            "cannot view the Review list of the person",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_SHORT);
                  }
                },
                color: Colors.white,
                textColor: Colors.black,
                child: Text("Review list", style: TextStyle(fontSize: 16)),
              ),
            ),
          ]),
        ),
        Divider(color: Colors.black,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('User is private, Follow user to view details'),
        )
      ],
    );
  }

  Widget normalContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: DatabaseServices(User.userdata.uid)
                      .getFriendInfo(uid: args.id),
                  builder: (context, AsyncSnapshot<UserDetails> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return CircleAvatar(
                      radius: 70,
                      backgroundImage: ImageServices.profileImage(
                          snapshot.data.photo_profile),
                    );
                  },
                ),
              ],
            ),
            new Positioned(
              right: 10,
              top: 0,
              child: BlockedButton(id: args.id),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(args.userName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          ButtonTheme(
            minWidth: 120.0,
            height: 50.0,
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  side: BorderSide(color: Colors.blue)),
              color: pressed ? Colors.white : Colors.blue,
              textColor: pressed ? Colors.black : Colors.white,
              child: new Text(strText),
              onPressed: () async {
                if (pressed == true) {
                  strText = 'Request Pending';
                  await DatabaseServices(User.userdata.uid).follow(args.id);
                } else {
                  strText = 'Follow';
                  await DatabaseServices(User.userdata.uid).unFollow(args.id);
                }
                pressed = !pressed;
                dataRetrieved = false;
                setState(() {});
              },
            ),
          ),
          ButtonTheme(
            minWidth: 120.0,
            height: 50.0,
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  side: BorderSide(color: Colors.blue)),
              onPressed: () async {
                if (await DatabaseServices(User.userdata.uid)
                    .isFollowing(uid: args.id)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WatchList(
                        uid: args.id,
                        index: 0,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "You're not a follower/ person hasnt accepted you "
                          "therefore you "
                          "cannot view the watch list of the person",
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_SHORT);
                }
              },
              color: Colors.white,
              textColor: Colors.black,
              child: Text("Watch List", style: TextStyle(fontSize: 16)),
            ),
          ),
          ButtonTheme(
            minWidth: 120.0,
            height: 50.0,
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  side: BorderSide(color: Colors.blue)),
              onPressed: () async {
                if (await DatabaseServices(User.userdata.uid)
                    .isFollowing(uid: args.id)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WatchList(
                        uid: args.id,
                        index: 1,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "You're not a follower/ person hasnt accepted you "
                          "therefore you "
                          "cannot view the Review list of the person",
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_SHORT);
                }
              },
              color: Colors.white,
              textColor: Colors.black,
              child: Text("Review list", style: TextStyle(fontSize: 16)),
            ),
          ),
        ]),
        Divider(color: Colors.black,),
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
            FutureBuilder(
              future: DatabaseServices(args.id).getFriendInfo(uid: args.id),
              builder:
                  (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
                if (!snapshot.hasData)
                  return Text('Waiting',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]));
                UserDetails content = snapshot.data;
                return FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: new AlertDialog(
                          content: new Text(content.favorite_movie),
                        ));
                  },
                  child: Container(
                    width: 105,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          text: content.favorite_movie),
                    ),
                  ),
                );
              },
            ),
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
              child: FutureBuilder(
                  future: DatabaseServices(args.id).getFriendInfo(uid: args.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserDetails> snapshot) {
                    if (!snapshot.hasData)
                      return Text('Waiting...',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold));
                    UserDetails content = snapshot.data;
                    return Text('${content.favorite_category}',
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
              child: Text('Followers',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600])),
            ),
            Container(
              width: 120,
              child: FutureBuilder(
                  future: followers,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
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
              child: FutureBuilder(
                  future: DatabaseServices(args.id).getFriends(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
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
              child: FutureBuilder(
                  future: reviewlist,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
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
              child: Text('Category most watched',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600])),
            ),
            Container(
              width: 120,
              child: FutureBuilder(
                  future: reviewlist,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                    List<String> movieList =
                        content.map((review) => (review.movie_id)).toList();
                    return FutureBuilder(
                      future: _getMostWatched(movieList),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> mostWatched) {
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
              child: FutureBuilder(
                  future: DatabaseServices(args.id).getFriendInfo(uid: args.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<UserDetails> snapshot) {
                    if (!snapshot.hasData)
                      return Text('Waiting...',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold));
                    UserDetails content = snapshot.data;
                    return Text('${content.gender}',
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
              child: Text('Date of birth',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600])),
            ),
            Container(
              width: 120,
              child: FutureBuilder(
                future: DatabaseServices(args.id).getFriendInfo(uid: args.id),
                builder: (BuildContext context,
                    AsyncSnapshot<UserDetails> snapshot) {
                  if (!snapshot.hasData)
                    return Text('Waiting...',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  UserDetails content = snapshot.data;
                  return Text('${getTimeText(content.dob)}',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
