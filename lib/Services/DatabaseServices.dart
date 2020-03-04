import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {

  DatabaseServices();

  Future setUsername({String uid, String username}) async{
    try {
      return await Firestore.instance.collection("Users").document(uid).updateData(
        {
          'user_name': username
        },
      ).whenComplete((){
        print("Done");
      });
    } catch (e) {
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
