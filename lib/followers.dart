import 'package:flutter/material.dart';
import 'followers_card.dart';

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {

  int currentindex = 0; // home = 0

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Followers",),
                Tab(text: "Following")
              ],
            ),
            backgroundColor: Colors.blue[900],
            title: Text('Followers List'),
          ),

          body: TabBarView(
            children: <Widget>[

              //followers tab
              ListView(
                children: <Widget>[
                  FollowersCard(viewProfile: (){},name:"Winnie Horner", friend: true),
                  FollowersCard(viewProfile: (){},name:"Jeff Smith", friend: true),
                  FollowersCard(viewProfile: (){},name:"Olli Holder", friend: true),
                  FollowersCard(viewProfile: (){},name:"Keyaan Major", friend: true),
                  FollowersCard(viewProfile: (){},name:"Eoin Andrews", friend: false),
                  FollowersCard(viewProfile: (){},name:"Sabiha Cannon", friend: false),
                  FollowersCard(viewProfile: (){},name:"Rahma Landry", friend: false),
                  FollowersCard(viewProfile: (){},name:"Aida Brett", friend: false),
                  FollowersCard(viewProfile: (){},name:"Nate O'Ryan", friend: false),
                  FollowersCard(viewProfile: (){},name:"Christian Rocha", friend: false),
                ],
              ),

              //following tab
              ListView(
                children: <Widget>[
                  FollowersCard(viewProfile: (){},name:"Winnie Horner", friend: true),
                  FollowersCard(viewProfile: (){},name:"Jeff Smith", friend: true),
                  FollowersCard(viewProfile: (){},name:"Olli Holder", friend: true),
                  FollowersCard(viewProfile: (){},name:"Keyaan Major", friend: true),
                  FollowersCard(viewProfile: (){},name:"Nina Lowery", friend: false),
                  FollowersCard(viewProfile: (){},name:"Daniele Frederick", friend: false),
                  FollowersCard(viewProfile: (){},name:"Bridget Dotson", friend: false),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }
}