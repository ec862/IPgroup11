import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Models/UserDetails.dart';
import 'package:template/Models/User.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:template/Services/ImageServices.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class EditProfile extends StatefulWidget {
  @override
  final String text;

  EditProfile({Key key, @required this.text}) : super(key: key);

  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String gender = "Male";
  DateTime dob;
  UserDetails userDetails;
  TextEditingController nameController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController favMovieController = new TextEditingController();

  String currentSelectedValue = 'Male';
  String currentSelectedValueCat = "Action";
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  var dateFormat = DateFormat('d/MM/yyyy');
  File _pickedImage;
  String imageUrl = "";

  void getCurrentUser() async {
    userDetails = await DatabaseServices(User.userdata.uid).getUserInfo();
    dob = userDetails.dob.toDate();
    nameController.text = userDetails.name;
    userNameController.text = userDetails.user_name;
    favMovieController.text = userDetails.favorite_movie;
    currentSelectedValueCat = userDetails.favorite_category;
    currentSelectedValue = userDetails.gender;
    selectedDate = userDetails.dob.toDate();
    imageUrl = userDetails.photo_profile;

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
    if (_pickedImage != null)
      dbs.setProfilePhoto(image: _pickedImage);
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

  Future<File> _pickImage() async {
    try {
      final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Add profile picture!"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ),
      );
      return await ImagePicker.pickImage(source: imageSource);
    }catch(e){
      print(e);
      return null;
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.start,
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
                      backgroundImage: _pickedImage != null
                          ? ImageServices.profileFromFile(_pickedImage)
                          : ImageServices.profileImage(imageUrl),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: 50,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                      elevation: 0,
                      onPressed: () async {
                        _pickedImage = await _pickImage();
                        setState(() {});
                      },
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
                            String errorMsg = "";
                            if (favMovieController.text.replaceAll(' ', '') ==
                                "") {
                              errorMsg =
                                  "Please type in your favorite Movie.\n";
                            }

                            if (nameController.text.replaceAll(' ', '') == "") {
                              errorMsg += "Please type in your name.";
                            }

                            if (errorMsg != "") {
                              Widget okButton = FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                },
                              );
                              showDialog(
                                  context: context,
                                  child: new AlertDialog(
                                    title: new Text("Validation Message."),
                                    content: new Text(errorMsg),
                                    actions: [
                                      okButton,
                                    ],
                                  ));
                            } else {
                              setCurrentUser();
                              print("new Info saved");
                              if (User.userdata.firstLogIn) {
                                User.userdata.firstLogIn = false;
                                DatabaseServices(User.userdata.uid)
                                    .setFirstTimeLogIn(state: false);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  ModalRoute.withName('/'),
                                );
                              } else
                                Navigator.pop(context);
                            }
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                //padding: EdgeInsets.only(left: 20),
                child: Text('Favorite Movie',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: 120,
                  child: new TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    controller: favMovieController,
                    //textAlign: TextAlign.center,
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
                padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: Text('Favorite Category',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                width: 120,
                child: DropdownButton<String>(
                  value: currentSelectedValueCat.isNotEmpty
                      ? currentSelectedValueCat
                      : null,
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
                padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
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
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                width: 120,
                child: DropdownButton<String>(
                  value: currentSelectedValue.isNotEmpty
                      ? currentSelectedValue
                      : null,
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
                padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
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
            transform: Matrix4.translationValues(275, -40, 0.0),
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
                        hintText: DateFormat('d/MM/yyyy').format(selectedDate),
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
