import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/Models/User.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Services/DatabaseServices.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Settings'),
      ),
      body: StreamBuilder<UserDetails>(
        stream: DatabaseServices(User.userdata.uid).userStream,
        builder: (context, AsyncSnapshot<UserDetails> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Account Private',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Switch(
                      value: snapshot.data.is_private,
                      onChanged: (value) async {
                        await DatabaseServices(User.userdata.uid)
                            .setPrivate(value);
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: Text(
                  'When account is private you have to accept people '
                  'before they can follow you,'
                  'When public every request is atomatically is a follower',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
