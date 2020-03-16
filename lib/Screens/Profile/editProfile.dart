import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/Services/AuthenticationServices.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Models/User.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class EditProfile extends StatefulWidget {
  @override
  final String text;

  EditProfile({Key key, @required this.text}) : super(key: key);

  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String gender = "Male";
  String dob = "08/09/2000";

  UserDetails userDetails;

  TextEditingController nameController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController favMovieController = new TextEditingController();
  String currentSelectedValue = 'Male';
  String currentSelectedValueCat = "Action";
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  var dateFormat = DateFormat('d/MM/yyyy');

  void getCurrentUser() async {
    userDetails = await DatabaseServices(User.userdata.uid).getUserInfo();
    nameController.text = userDetails.name;
    userNameController.text = userDetails.user_name;
    favMovieController.text = userDetails.favorite_movie;
    currentSelectedValueCat = userDetails.favorite_category;
    currentSelectedValue = userDetails.gender;
    dob = userDetails.dob;

    setState(() {});
  }

  void setCurrentUser() async {
    DatabaseServices dbs = new DatabaseServices(User.userdata.uid);
    dbs.setName(name: this.nameController.text);
    dbs.setUsername(username: this.userNameController.text);
    dbs.setFavMovie(movieName: this.favMovieController.text);
    dbs.setFavCategory(category: currentSelectedValueCat);
    dbs.setDOB(date: selectedDate);
    dbs.setGender(gender: this.gender);
  }

  _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1903, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value =
            TextEditingValue(text: ('${dateFormat.format(picked)}').toString());
      });
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Edit Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                width: 110,
                height: 140,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1501549538842-2f24e2dd6520?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: 50,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                      elevation: 0,
                      onPressed: () => {},
                      tooltip: 'Edit',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Edit"),
                        ],
                      ),
                      //label: Text('Approve'),
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  //color: Colors.red,
                  height: 100,
                  alignment: Alignment.topRight,
                  child: SizedBox.fromSize(
                    size: Size(56, 56), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.white, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // splash color
                          onTap: () {
                            setCurrentUser();
                            print("new Info saved");
                            Navigator.pop(context);
                          },
                          // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.save), // icon
                              Text("Save"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: 200,
                  child: new TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0, height: 1.0, color: Colors.black),
                    decoration: InputDecoration(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 150,
                  child: new TextField(
                    controller: userNameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0, height: 1.0, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Favorite Movie',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: new TextField(
                  controller: favMovieController,
                  //textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 18.0, height: 0, color: Colors.black),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Favorite Category',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: currentSelectedValueCat.isNotEmpty ? currentSelectedValueCat : null,
                  onChanged: (newVal) {
                    setState(() {
                      this.currentSelectedValueCat = newVal;
                    });
                  },
                  items: <String>[
                    'Action',
                    'Comedy',
                    'Thriller',
                    'Horror',
                    'Family'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: currentSelectedValue.isNotEmpty ? currentSelectedValue : null,
                  onChanged: (newVal) {
                    setState(() {
                      currentSelectedValue = newVal;
                      gender = newVal;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other', 'Not say']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Date of birth',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          Transform(
            transform: Matrix4.translationValues(275, -80, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _selectDate(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _date,
                      //keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: dob,
                        border: InputBorder.none,
                        //hasFloatingPlaceholder: true
                      ),
                    ),
                  ),
                ), //child: Text('Date of Birth'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
