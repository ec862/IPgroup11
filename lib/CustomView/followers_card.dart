import 'package:flutter/material.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';

class FollowersCard extends StatefulWidget {
  final uid;
  final bool isAccepted;
  final bool isFollowers;
  final Function reset;

  FollowersCard({this.uid, this.isAccepted, this.isFollowers, this.reset});

  @override
  _FollowersCardState createState() => _FollowersCardState();
}

class _FollowersCardState extends State<FollowersCard> {
  bool isAccepted;
  bool isFollowers;

  @override
  void initState() {
    super.initState();
    isAccepted = widget.isAccepted;
    isFollowers = widget.isFollowers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          DatabaseServices(User.userdata.uid).getFriendInfo(uid: widget.uid),
      builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
        if (!snapshot.hasData)
          return card(context,
              profile:
                  'https://buildflutter.com/wp-content/uploads/2018/04/buildflutter_255.png',
              username: 'Waiting...');

        if (snapshot.data == null)
          return card(
            context,
            profile:
                'https://buildflutter.com/wp-content/uploads/2018/04/buildflutter_255.png',
            username: 'Error with person',
          );
        UserDetails user = snapshot.data;
        return card(
          context,
          profile:
              'https://buildflutter.com/wp-content/uploads/2018/04/buildflutter_255.png',
          username: user.user_name,
        );
      },
    );
  }

  Widget card(context, {String profile, String username}) {
    return Card(
      child: ListTile(
        leading: Container(
          height: 55.0,
          width: 55.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: ImageServices.profileImage(
              'https://buildflutter.com/wp-content/uploads/2018/04/buildflutter_255.png',
            ),
          ),
        ),
        title: Text(username),
        subtitle: isAccepted
            ? checkWhetherFriends()
            : Text(isFollowers
                ? "You haven't accepted user"
                : "Waiting for user to accept"),
        trailing: isFollowers
            ? (isAccepted
                ? IconButton(
                    onPressed: () async {
                      await DatabaseServices(User.userdata.uid)
                          .declineFollowing(widget.uid);
                      widget.reset();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.redAccent,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Options'),
                            content: Text("Choose what to do with follow request"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("decline"),
                                onPressed: () async {
                                  await DatabaseServices(User.userdata.uid)
                                      .declineFollowing(widget.uid);
                                  widget.reset();
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Accepted"),
                                onPressed: () async {
                                  await DatabaseServices(User.userdata.uid)
                                      .acceptFollowing(widget.uid);
                                  isAccepted = true;
                                  setState(() {});
                                  widget.reset();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );;
                        },
                      );
                    },
                    icon: Icon(
                      Icons.menu
                    ),
                  ))
            : Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/otherProfile',
            arguments: OtherProfileArgument(id: widget.uid, userName: username),
          );
        },
      ),
    );
  }

  Widget checkWhetherFriends() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return Text("Waiting...");

        return snapshot.data ? Text("firend") : Text("");
      },
      future: isFollowers
          ? DatabaseServices(User.userdata.uid).isFollowing(uid: widget.uid)
          : DatabaseServices(User.userdata.uid).isFollower(uid: widget.uid),
    );
  }
}
