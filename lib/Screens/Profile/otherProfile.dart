import 'package:flutter/material.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Models/User.dart';
import 'package:template/Services/DatabaseServices.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class OtherProfile extends StatefulWidget {
  OtherProfile({Key key}) : super(key: key);
  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  bool pressed = true;
  String strText = 'Follow';
  OtherProfileArgument args;
  bool dataRetrieved = false;

  void getData() async {
    if (await DatabaseServices(User.userdata.uid).isFollowing(uid: args.id)) {
      pressed = false;
      strText = 'UnFollow';
    }
    dataRetrieved = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    if (!dataRetrieved) getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(args.userName),
        actions: <Widget>[
          FutureBuilder(
            future:
                DatabaseServices(User.userdata.uid).isFollower(uid: args.id),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) return Text("");

              return snapshot.data
                  ? FutureBuilder(
                      future: DatabaseServices(User.userdata.uid)
                          .isFollowing(uid: args.id),
                      builder: (context, snap) {
                        if (!snapshot.hasData) return Text("");
                        return snapshot.data
                            ? IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/chatMessages',
                                    arguments:
                                        ChatMessagesArgument(id: args.id),
                                  );
                                },
                                icon: Icon(Icons.message),
                              )
                            : Text("");
                      },
                    )
                  : Text("");
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1501549538842-2f24e2dd6520?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(args.userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      side: BorderSide(color: Colors.blue)),
                  color: pressed ? Colors.white : Colors.blue,
                  textColor: pressed ? Colors.black : Colors.white,
                  child: new Text(strText),
                  onPressed: () {
                    setState(() {
                      if (pressed == true) {
                        strText = 'Unfollow';
                        DatabaseServices(User.userdata.uid).follow(args.id);
                      } else {
                        strText = 'Follow';
                        DatabaseServices(User.userdata.uid).unFollow(args.id);
                      }
                      pressed = !pressed;
                    });
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
                  onPressed: () {},
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
                  onPressed: () {},
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text("Review list", style: TextStyle(fontSize: 16)),
                ),
              ),
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
              Container(
                width: 120,
                child: Text('Joker',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('Thriller',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('22',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('10',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('30',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('Action',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('Male',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('08/09/2000',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
