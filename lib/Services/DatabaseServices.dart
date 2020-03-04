import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {

  DatabaseServices();

  Future setUsername({String uid, String username}) async{
    try {
      return await Firestore.instance.collection("Users").document(uid).setData(
        {
          'user_name': username
        },
      ).whenComplete((){
        print("Done");
      });
    } catch (e) {
      print(e);
      try {
        return await Firestore.instance.collection("Users").document(uid).setData(
          {
            'user_name': username
          },
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }
}
