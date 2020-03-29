import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/Models/User.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signUp(
      {String email, String password, String username}) async {
    try {
      AuthResult user = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((AuthResult res) {
        res.user.sendEmailVerification();
        _showToast(
          "Verification email sent to your email please check your emails",
        );
        return res;
      });
      return user.user;
    } catch (signupError) {
      if (signupError.toString().contains("Given String is empty or null")) {
        _showToast("Please enter text in fields");
      } else if (signupError.toString().contains("ERROR_WRONG_PASSWORD")) {
        _showToast("Password Invalid");
      } else if (signupError.toString().contains("ERROR_INVALID_EMAIL")) {
        _showToast("Invalid Email");
      } else if (signupError.toString().contains("ERROR_WEAK_PASSWORD")) {
        _showToast("Password too weak");
      } else if (signupError
          .toString()
          .contains("ERROR_EMAIL_ALREADY_IN_USE")) {
        _showToast("Email already in use");
      } else {
        _showToast("Please enter an email");
      }
      print(signupError);
      return null;
    }
  }

  Future<FirebaseUser> signIn({String email, String password}) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = res.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signOut() {
    _auth.signOut();
    User.userdata.uid = null;
  }

  void _showToast(txt) {
    Fluttertoast.showToast(
      msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }

  void ForgotPassword({email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showToast("Email sent");
    } catch (e) {
      _showToast("Error");
    }
  }

  Future<FirebaseUser> get user {
    return _auth.currentUser();
  }

  Future deleteUser({String uid}) async {
    FirebaseUser user = await _auth.currentUser();
    return user.delete();
  }
}
