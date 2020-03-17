import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';
import '../../CustomView/followers_card.dart';

class Followers extends StatefulWidget {
  final int index;

  Followers({@required this.index});

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.index,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Followers",
              ),
              Tab(text: "Following")
            ],
          ),
          backgroundColor: Colors.blue[900],
          title: Text('Followers List'),
        ),
        body: TabBarView(
          children: <Widget>[
            //followers tab
            getFollowers(),
            //following tab
            getFollowing(),
          ],
        ),
      ),
    );
  }

  Widget getFollowing() {
    Future<List<FollowerDetails>> followers =
        DatabaseServices(User.userdata.uid).getFollowing();
    return FutureBuilder(
      future: followers,
      builder: (BuildContext context,
          AsyncSnapshot<List<FollowerDetails>> snapshot) {
        if (!snapshot.hasData)
          return Container(
            child: Center(
              child: Text("Waiting..."),
            ),
          );
        if (snapshot.data == null || snapshot.data.isEmpty)
          return Container(
            child: Center(
              child: Text("You're not following anyone at the moment"),
            ),
          );

        List<FollowerDetails> content = snapshot.data;
        return ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            return FollowersCard(
              uid: content[index].user_id,
              isAccepted: content[index].accepted,
              isFollowers: false,
            );
          },
        );
      },
    );
  }

  Widget getFollowers() {
    Future<List<FollowerDetails>> followers =
        DatabaseServices(User.userdata.uid).getFollowers();
    return FutureBuilder(
      future: followers,
      builder: (BuildContext context,
          AsyncSnapshot<List<FollowerDetails>> snapshot) {
        if (!snapshot.hasData)
          return Container(
            child: Center(
              child: Text("Waiting..."),
            ),
          );

        if (snapshot.data == null || snapshot.data.isEmpty)
          return Container(
            child: Center(
              child: Text("No one is following you at the moment"),
            ),
          );

        List<FollowerDetails> content = snapshot.data;
        return ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            return FollowersCard(
              uid: content[index].user_id,
              isAccepted: content[index].accepted,
              isFollowers: true,
              reset: (){
                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
