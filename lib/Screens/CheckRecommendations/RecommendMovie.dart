import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendMovie extends StatefulWidget {
  @override
  _RecommendMovieState createState() => _RecommendMovieState();
}

class _RecommendMovieState extends State<RecommendMovie> {
  List<Person> friends = [];

  @override
  void initState() {
    super.initState();
    var names = ["Ed","Cheng", "Arron", "Andrez", "Luke", "Umar", "Zee"];
    for (int i = 0; i < names.length; i++) {
      friends.add(
        Person(
          selected: false,
          profile: "asserts/no_picture_avatar.jpg",
          name: names[i],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Recommend"),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: SizedBox(
              width: 100,
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: friends[index].selected,
                    onChanged: (state) {
                      setState(() {
                        friends[index].selected = state;
                      });
                    },
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(friends[index].profile),
                  ),
                ],
              ),
            ),
            title: Text("${friends[index].name}"),
            onTap: () {
              setState(() {
                friends[index].selected = !friends[index].selected;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: Text("Send"),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}

class Person {
  bool selected = false;
  String profile = "asserts/no_picture_avatar.jpg";
  String name;
  String uid;

  Person({this.selected, this.profile, this.name});
}
