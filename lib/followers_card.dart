import 'package:flutter/material.dart';

class FollowersCard extends StatelessWidget {

  final Function viewProfile;
  final String name;
  final bool friend;
  FollowersCard({this.viewProfile, this.name, this.friend});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.person,
          size: 64.0,
        ),
        title: Text(name),
        subtitle: friend ? Text("Friend"): Text(""),
        trailing: IconButton(
          onPressed: viewProfile,
          icon: Icon(Icons.arrow_forward_ios, color: Colors.grey,),
        ),
      ),
    );
  }
}
