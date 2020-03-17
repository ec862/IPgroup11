import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/Models/Arguments.dart';
import 'package:template/Models/Message.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages();

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  ChatMessagesArgument args;
  TextEditingController _textController;
  String text = "";
  bool messageSent = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      text = _textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: FutureBuilder(
            future:
                DatabaseServices(User.userdata.uid).getFriendInfo(uid: args.id),
            builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data == null) Navigator.of(context).pop();
              return Text(snapshot.data.user_name);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: getTexts(),
            ),
            getTextField(),
          ],
        ),
      ),
    );
  }

  Widget getTexts() {
    return StreamBuilder(
      stream: DatabaseServices(User.userdata.uid).getMessages(uid: args.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        if (snapshot.data == null)
          return Center(
            child: Text(""),
          );
        List<Message> messages = [];
        snapshot.data.documents.forEach((DocumentSnapshot snap) {
          messages.add(Message(
            message: snap.data['message'],
            senderID: snap.data['sender_id'],
          ));
        });

        return ListView.builder(
          itemBuilder: (context, index) {
            return textBox(
              message: messages[index].message,
              isSender:
                  User.userdata.uid == messages[index].senderID ? true : false,
            );
          },
          itemCount: messages.length,
        );
      },
    );
  }

  Widget getTextField() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(40.0),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (text.trim().length > 0) {
              DatabaseServices(User.userdata.uid).sendMessage(
                message: text,
                uid: args.id,
              ).whenComplete((){
                messageSent = true;
              });
              _textController.clear();
            }
          },
          icon: Icon(Icons.send),
          color: Colors.blue[900],
          iconSize: 40,
        ),
      ],
    );
  }

  Widget textBox({String message, bool isSender = false}) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 300),
          decoration: BoxDecoration(
            color: isSender ? Colors.white : Colors.blue[900],
            border: Border.all(
              color: isSender ? Colors.black : Colors.blue[900],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                message,
                style: TextStyle(color: isSender ? Colors.black : Colors.white),
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          margin: EdgeInsets.only(bottom: 5.0, right: isSender ? 0.0 : 10.0)),
    );
  }

  Future<bool> _onBackPressed() async {
    if (messageSent)
      await DatabaseServices(User.userdata.uid).addNewChatPerson(uid: args.id);
    return true;
  }

}
