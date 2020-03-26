import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/CustomView/comment_view.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';

class FriendsRating extends StatelessWidget {
  final movieId;

  FriendsRating(this.movieId);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: DatabaseServices(User.userdata.uid).getFriendReview(
          movieID: movieId,
        ),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ReviewDetails>> snapshot,
        ) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data == null)
            return Center(
              child: Text("You're friends haven't rated"),
            );
          if (snapshot.data.length == 0)
            return Center(
              child: Text("\n Your friends haven't rated this movie"),
            );
          int count = snapshot.data.length < 3 ? snapshot.data.length : 3;
          List<Widget> widgets = [];
          for (int index = 0; index < count; index++){
            widgets.add(
                FutureBuilder(
                  future: DatabaseServices(User.userdata.uid).getFriendInfo(
                    uid: snapshot.data[index].userId,
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot<UserDetails> snap) {
                    if (!snap.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return CommentView(
                      rating: snapshot.data[index].rating,
                      image: "asserts/no_picture_avatar.jpg",
                      name: snap.data != null ? snap.data.name : 'No name',
                      text: snapshot.data[index].comment,
                    );
                  },
                )
            );
            if (index < count-1)
              widgets.add(
                Divider(
                  color: Colors.black,
                  indent: 50,
                )
              );
          }

          if (snapshot.data.length > 3)
            widgets.add(
              InkWell(
                onTap: () {},
                child: Text(
                  "Load More",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            );

          return Column(
            children: widgets,
          );
        },
      ),
    );
  }
}
