import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference users_collection =
      Firestore.instance.collection("Users");

  Future setUsername({String uid, String username}) async{
    try {
      return await users_collection.document(uid).updateData(
        {
          'username': username
        },
      );
    } catch (e) {
      print(e);
      try {
        return await users_collection.document(uid).setData(
          {
            'username': username
          },
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }
}
