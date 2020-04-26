import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:template/Models/User.dart';
import 'package:template/Screens/main.dart';
import 'package:template/Services/AuthenticationServices.dart';
import 'package:template/Services/DatabaseServices.dart';

enum AuthMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // To adjust the layout according to the screen size
  // so that our layout remains responsive ,we need to
  // calculate the screen height
  double screenHeight;
  bool checkBoxValue = false;

  // Set initial mode to login
  AuthMode _authMode = AuthMode.LOGIN;
  DateTime selectedDate = DateTime.now();
  var dateFormat = DateFormat('d-MM-yyyy');
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  String signUpEmail = "";
  String signUpPassword = "";
  String signUpUsername = "";
  String signUpConfirmPassword = "";
  String signInEmail = "";
  String signInPassword = "";

  void getCurrentUser() async {
    FirebaseUser user = await Authentication().user;
    if (user == null) return;

    if (user.isEmailVerified) {
      User.userdata.uid = user.uid;
      User.userdata.firstLogIn =  await DatabaseServices(User.userdata.uid).isFirstTimeLogin();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MainApp();
      }));
    } else {
      Fluttertoast.showToast(
        msg: "Please verify your email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    getCurrentUser();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            lowerHalf(context),
            upperHalf(context),
            _authMode == AuthMode.LOGIN
                ? loginCard(context)
                : signUpCard(context),
            //pageTitle(),
          ],
        ),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 3.3,
      //child: Padding(
        //padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'asserts/MofloLogo2.png',
          fit: BoxFit.cover,
        ),
      );
    //);
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 1,
        child: Image.asset(
        'asserts/Bottom.png',
        fit: BoxFit.cover,
        ),
        //color: Color(0xFFECF0F3),
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_movies,
            size: 48,
            color: Colors.black,
          ),
          Text(
            "Enter name here",
            style: TextStyle(
                fontSize: 34, color: Colors.black, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter email' : null,
                      decoration: InputDecoration(
                        labelText: "Your Email",
                        hasFloatingPlaceholder: true,
                      ),
                      onChanged: (val) {
                        signInEmail = val;
                        _signInFormKey.currentState.validate();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        hasFloatingPlaceholder: true,
                      ),
                      onChanged: (val) {
                        signInPassword = val;
                        _signInFormKey.currentState.validate();
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ForgotPage();
                            }));
                          },
                          child: Text("Forgot Password?"),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        FlatButton(
                          child: Text("Login"),
                          color: Color(0xFF4B9DFE),
                          textColor: Colors.white,
                          padding: EdgeInsets.only(
                              left: 38, right: 38, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () async {
                            // login
                            FirebaseUser user = await Authentication().signIn(
                              email: signInEmail,
                              password: signInPassword,
                            );
                            if (user == null) {
                              Fluttertoast.showToast(
                                msg: "Wrong Email/ Password",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                              );
                            } else {
                              if (user.isEmailVerified) {
                                User.userdata.uid = user.uid;
                                User.userdata.firstLogIn =  await DatabaseServices(User.userdata.uid).isFirstTimeLogin();
                                print('hello');
                                return Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return MainApp();
                                }));
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Please verify email address",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _authMode = AuthMode.SIGNUP;
                            });
                          },
                          textColor: Colors.black87,
                          child: Text("Create Account"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter username' : null,
                      decoration: InputDecoration(
                        labelText: "Username",
                        hasFloatingPlaceholder: true,
                      ),
                      onChanged: (val) {
                        signUpUsername = val;
                        _signUpFormKey.currentState.validate();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter email' : null,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hasFloatingPlaceholder: true,
                      ),
                      onChanged: (val) {
                        signUpEmail = val;
                        _signUpFormKey.currentState.validate();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.length < 6 ? 'password too short' : null,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hasFloatingPlaceholder: true,
                      ),
                      onChanged: (val) {
                        signUpPassword = val;
                        _signUpFormKey.currentState.validate();
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.length < 6 ? 'password too short' : null,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hasFloatingPlaceholder: true,
                      ),
                      onChanged: (val) {
                        signUpConfirmPassword = val;
                        _signUpFormKey.currentState.validate();
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Password must be at least 8 characters and include a special character and number",
                      style: TextStyle(color: Colors.grey),
                    ),
                    new Text(''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        FlatButton(
                          child: Text("Sign Up"),
                          color: Color(0xFF4B9DFE),
                          textColor: Colors.white,
                          padding: EdgeInsets.only(
                              left: 38, right: 38, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () async {
                            // sign up
                            if (_signUpFormKey.currentState.validate()) {
                              if (signUpPassword == signUpConfirmPassword) {
                                FirebaseUser result = await Authentication().signUp(
                                    email: signUpEmail.trim(),
                                    password: signUpPassword);
                                if (result != null) {
                                  User.userdata.uid = result.uid;
                                  await DatabaseServices(result.uid)
                                      .setUsername(username: signUpUsername.trim());

                                  await DatabaseServices(result.uid)
                                      .setFirstTimeLogIn(state: true);

                                  await DatabaseServices(result.uid)
                                      .setFriendRequests(
                                      number: 0, theirUID: result.uid);
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Passwords do not match",
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _authMode = AuthMode.LOGIN;
                            });
                          },
                          textColor: Colors.black87,
                          child: Text("Login"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
//        Align(
//          alignment: Alignment.bottomCenter,
//          child: FlatButton(
//            child: Text(
//              "Terms & Conditions",
//              style: TextStyle(
//                color: Colors.grey,
//              ),
//            ),
//            onPressed: () {},
//          ),
//        ),
      ],
    );
  }

/*
TextEditingController _date = new TextEditingController();
Future _selectDate() async {
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
  

                    GestureDetector(
                      onTap: () => _selectDate(),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _date,
                          //keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: "Date of Birth",
                            hasFloatingPlaceholder: true,
                          ),
                        ),
                      ),
                    )
  */
}

class ForgotPage extends StatefulWidget {
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  double screenHeight;
  String email = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            lowerHalf(context),
            upperHalf(context),
            forgotCard(context),
            //pageTitle(),
          ],
        ),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 3.3,
      child: Image.asset(
        'asserts/MofloLogo2.png',
        fit: BoxFit.cover,
      ),
        );
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 1,
        child: Image.asset(
          'asserts/Bottom.png',
          fit: BoxFit.cover,
        ),
        //color: Color(0xFFECF0F3),
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_movies,
            size: 48,
            color: Colors.black,
          ),
          Text(
            "Enter name here",
            style: TextStyle(
                fontSize: 34, color: Colors.black, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget forgotCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Forgot Your Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  new Text(""),
                  new Text(
                      "Enter email you registered with and we will send you a link to reset your password"),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Your Email",
                      hasFloatingPlaceholder: true,
                    ),
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton(
                    child: Text("Send Link"),
                    color: Color(0xFF4B9DFE),
                    textColor: Colors.white,
                    padding: EdgeInsets.only(
                        left: 38, right: 38, top: 15, bottom: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      // send password forgot
                      Authentication().ForgotPassword(email: email);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
