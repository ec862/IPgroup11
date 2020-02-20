import 'package:flutter/material.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int currentindex = 0; // home = 0
  var currentSelectedValue = 'Male';
  var currentSelectedValueCat = 'Action';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Edit Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 110,
                height: 140,
              ),
              /*Container(
                  color: Colors.red,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(''),
                  ),
                ),*/
              Stack(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1501549538842-2f24e2dd6520?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80'),
                    ),
                  ),
                  Container(
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
                width: 110,
                height: 140,
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.save,
                  ),
                  //elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                /*Icon(
                    Icons.edit,
                    size: 30,
                  ),*/
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //Text('Frank Davis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Flexible(
                child: Container(
                  width: 120,
                  child: new TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0, height: 1.0, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Frank Davis',
                    ),
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
              /*Container(
                  width: 120,
                  child: Text('Joker', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),*/

              Container(
                width: 120,
                child: new TextField(
                  //textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 18.0, height: 0, color: Colors.black),

                  decoration: InputDecoration(
                    hintText: 'Joker',
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
                child: Text('Favorite Category',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: currentSelectedValueCat,
                  onChanged: (newVal) {
                    setState(
                      () {
                        print(newVal);
                        currentSelectedValueCat = newVal;
                      },
                    );
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
                //width: 120,
                //child: Text('Male', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              /*Container(
                  width: 120,
                  child: Text('Thriller', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),*/
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Followers',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: Text('22',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Friends',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: Text('10',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Reviewed movies',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: Text('30',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Category most watched',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: Text('Action',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Gender',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: currentSelectedValue,
                  onChanged: (newVal) {
                    setState(
                      () {
                        print(newVal);
                        currentSelectedValue = newVal;
                      },
                    );
                  },
                  items: <String>['Male', 'Female', 'Other', 'Not say']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                //width: 120,
                //child: Text('Male', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Date of birth',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              Container(
                width: 120,
                child: Text('08/09/2000',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
