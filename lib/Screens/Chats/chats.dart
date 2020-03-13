import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Services/ImageServices.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Chats"),
      ),
      body: FutureBuilder(
        future: DatabaseServices(User.userdata.uid).getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data == null) return Center(child: Text("No friends"));
          if (snapshot.data.isChatting == null) return Center(child: Text("No friends"));

          return ListView.separated(
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: DatabaseServices(User.userdata.uid)
                    .getFriendInfo(uid: snapshot.data.isChatting[index]),
                builder: (BuildContext context,
                    AsyncSnapshot<UserDetails> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  if (snapshot.data == null)
                    return Center(child: Text("No friends"));
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: ImageServices.profileImage(""),
                    ),
                    title: Text(snapshot.data.user_name??"No username"),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chatMessages',
                        arguments:
                            ChatMessagesArgument(id: snapshot.data.user_id),
                      );
                    },
                    trailing: Icon(Icons.message),
                  );
                },
              );
            },
            itemCount: snapshot.data.isChatting.length,
            separatorBuilder: (context, int) {
              return Divider(
                indent: 70,
                color: Colors.black,
              );
            },
          );
        },
      ),
    );
  }
}
