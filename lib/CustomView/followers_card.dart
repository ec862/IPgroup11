import 'package:flutter/material.dart';

class FollowersCard extends StatelessWidget {

  final Function viewProfile;
  final String name;
  final String img;
  final bool friend;
  FollowersCard({this.viewProfile, this.name, this.friend, this.img});

  @override
  Widget build(BuildContext context) {
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
            backgroundImage: NetworkImage(
                'https://buildflutter.com/wp-content/uploads/2018/04/buildflutter_255.png'),
          ),
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
