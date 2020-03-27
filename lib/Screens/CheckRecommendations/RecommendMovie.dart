import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/Models/AgeCalculator.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';

class RecommendMovie extends StatefulWidget {
  final movieID;
  final movieName;
  final movieRating;

  RecommendMovie(
      {this.movieID, this.movieName, this.movieRating = 'Not Rated'});

  @override
  _RecommendMovieState createState() => _RecommendMovieState();
}

class _RecommendMovieState extends State<RecommendMovie> {
  Map<String, Person> friends = Map();
  List<bool> canRec = [];

  @override
  Widget build(BuildContext context) {
    canRec = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Recommend"),
      ),
      body: FutureBuilder(
        future: DatabaseServices(User.userdata.uid).getFollowing(),
        builder: (BuildContext context,
            AsyncSnapshot<List<FollowerDetails>> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          if (snapshot.data == null || snapshot.data.isEmpty)
            return Container(
              child: Center(
                child: Text("You're not following anyone"),
              ),
            );
          List<FollowerDetails> temp = snapshot.data;
          List<FollowerDetails> content = [];
          for (int i = 0; i < temp.length; i++) {
            if (temp[i].accepted) {
              content.add(temp[i]);
            }
          }
          if (content.length <= 0)
            return Container(
              child: Center(
                child: Text("You're not following anyone"),
              ),
            );

          return ListView.builder(
            itemCount: content.length,
            itemBuilder: (context, index) {
              return personCard(content[index].user_id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          recommend();
        },
        label: Text("Send"),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget personCard(String uid) {
    return FutureBuilder(
      future: DatabaseServices(User.userdata.uid).getFriendInfo(uid: uid),
      builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
        if (!snapshot.hasData) return ListTile();

        if (snapshot.data == null) return ListTile();

        if (!friends.containsKey(snapshot.data.user_id)) {
          friends[snapshot.data.user_id] = Person(
            name: snapshot.data.user_name,
            uid: uid,
            canRecommendTo: AgeCalculator.canRecommendTo(
              rating: widget.movieRating,
              dob: snapshot.data.dob,
            )
          );
        }

        return ListTile(
          leading: SizedBox(
            width: 100,
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: friends[snapshot.data.user_id].selected,
                  onChanged: (state) {
                    friends[snapshot.data.user_id].selected = state;
                    print(friends[snapshot.data.user_id].selected);
                    setState(() {});
                  },
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: ImageServices.profileImage(snapshot.data.photo_profile),
                ),
              ],
            ),
          ),
          title: Text("${snapshot.data.user_name}"),
          onTap: () {
            setState(() {
              friends[snapshot.data.user_id].selected =
              !friends[snapshot.data.user_id].selected;
            });
          },
        );
      },
    );
  }

  void recommend() {
    List<Person> toRecommend = [];
    bool r = false;
    friends.forEach(
          (String key, Person person) {
        if (person.selected) {
          if (!person.canRecommendTo){
            Fluttertoast.showToast(
              msg: 'One or more of the chosen people is under age '
                  'and the movie cannot be recommended to',
              gravity: ToastGravity.CENTER,
            );
            r = true;
            return;
          }else{
            toRecommend.add(person);
          }
        }
      },
    );
    if (r)
      return;

    BaseDatabase db = DatabaseServices(User.userdata.uid);

    if (toRecommend == null || toRecommend.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please chose person to recommend movie",
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    for (int i = 0; i < toRecommend.length; i++) {
      db.recommendMovie(
        uid: toRecommend[i].uid,
        movieID: widget.movieID,
        movieName: widget.movieName,
      );
    }

    Fluttertoast.showToast(
      msg: "Movie Recommended",
      gravity: ToastGravity.CENTER,
    );

    Navigator.of(context).pop();
  }
}

class Person {
  bool selected = false;
  String profile = "asserts/no_picture_avatar.jpg";
  String name;
  String uid;
  bool canRecommendTo;

  Person({this.selected = false, this.profile, this.name, this.uid, this.canRecommendTo});
}
