import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:template/Models/Message.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Models/UserDetails.dart';

abstract class BaseDatabase {
  /// set details
  Future setUsername({@required String username});

  Future setName({@required String name});

  // not implemented yet
  Future setEmail({@required String email});

  Future setFavCategory({@required String category});

  Future setFavMovie({@required String movieName});

  Future setDOB({@required DateTime date});

  Future setProfilePhoto({@required File image});

  /// actions to perform
  Future follow(uid);

  Future acceptFollowing(uid);

  Future declineFollowing(uid);

  Future unFollow(uid);

  // not implemented yet
  Future block(uid);

  Future addToWatchList({@required String movieID, @required String movieName});

  Future removeFromWatchList({@required String movieID});

  Future removeRecommendation({String movieID});

  Future reviewMovie(
      {@required String movieID,
      @required double rating,
      @required String comment});

  Future recommendMovie(
      {@required String uid,
      @required String movieID,
      @required String movieName});

  Future<bool> isFollowing({@required String uid});

  Future<bool> isFollower({@required String uid});

  ///getters
  Future<List<String>> getWatchList();

  Future<List<ReviewDetails>> getReviewList();

  Future<UserDetails> getUserInfo();

  Future<UserDetails> getFriendInfo({@required String uid});

  Future<List<RecommendedMoviesDetails>> getRecommendations();

  Future<List<FollowerDetails>> getFollowers();

  Future<List<FollowerDetails>> getFollowing();

  Future<MovieDetails> getMovieDetails({@required String id});

  Future<List<Map<String, String>>> getPersonSuggestion(String suggestion);

  Stream<QuerySnapshot> getMessages({String uid});

  Future sendMessage({String uid, String message});

  Future addNewChatPerson({String uid});
}

class DatabaseServices implements BaseDatabase {
  String uid;
  CollectionReference _usersCollection;
  StorageReference _storageReference;
  CollectionReference _chatsCollection;

  /// uid is the id of person currently logged in
  /// btw to get this type 'User.userdata.uid'
  DatabaseServices(this.uid) {
    _usersCollection = Firestore.instance.collection("Users");
    _storageReference = FirebaseStorage.instance.ref().child("Images");
    _chatsCollection = Firestore.instance.collection("Chats");
  }

  List<String> _setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  Future setUsername({@required String username}) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'user_name': username, 'search_param': _setSearchParam(username)},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'user_name': username, 'search_param': _setSearchParam(username)},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future setDOB({@required DateTime date}) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'dob': date},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'dob': date},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future setEmail({@required String email}) {
    return null;
  }

  @override
  Future setFavCategory({@required String category}) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'favourite_category': category},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'favourite_category': category},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future setFavMovie({@required String movieName}) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'favourite_movie': movieName},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'favourite_movie': movieName},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future setName({@required String name}) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'name': name},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'name': name},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future setProfilePhoto({@required File image}) async {
    return await _upLoadImage(
      onData: (String url) {
        _uploadProfileUrl(image);
      },
      image: image,
    );
  }

  Future _uploadProfileUrl(url) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'photo_profile': url},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'photo_profile': url},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future addToWatchList(
      {@required String movieID, @required String movieName}) async {
    try {
      return await _usersCollection
          .document(this.uid)
          .collection("WatchList")
          .document(movieID)
          .updateData(
        {
          'movie_id': movieID,
          'movie_name': movieName,
        },
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection
            .document(this.uid)
            .collection("WatchList")
            .document(movieID)
            .setData(
          {
            'movie_id': movieID,
            'movie_name': movieName,
          },
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future block(uid) {
    return null;
  }

  @override
  Future follow(uid) async {
    try {
      return await _usersCollection
          .document(uid)
          .collection("Followers")
          .document(this.uid)
          .updateData(
        {
          'user_id': this.uid,
          'accepted': false,
        },
      ).whenComplete(() {
        print("Done");
        _addToYourFollowing(uid);
      });
    } catch (e) {
      try {
        return await _usersCollection
            .document(uid)
            .collection("Followers")
            .document(this.uid)
            .setData(
          {
            'user_id': this.uid,
            'accepted': false,
          },
        ).whenComplete(() {
          print("done");
          _addToYourFollowing(uid);
        });
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future acceptFollowing(uid) async {
    try {
      return await _usersCollection
          .document(this.uid)
          .collection("Followers")
          .document(uid)
          .updateData(
        {
          'accepted': true,
        },
      ).whenComplete(() async {
        _addToFollowing(uid, accepted: true);
      });
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future declineFollowing(uid) async {
    await _usersCollection
        .document(this.uid)
        .collection("Followers")
        .document(uid)
        .delete();
    await _usersCollection
        .document(uid)
        .collection("Following")
        .document(this.uid)
        .delete();
  }

  Future _addToFollowing(uid, {accepted = false}) async {
    await _usersCollection
        .document(uid)
        .collection("Following")
        .document(this.uid)
        .setData(
      {'user_id': this.uid, 'accepted': accepted},
    );
  }

  Future _addToYourFollowing(uid, {accepted = false}) async {
    await _usersCollection
        .document(this.uid)
        .collection("Following")
        .document(uid)
        .setData(
      {'user_id': uid, 'accepted': accepted},
    );
  }

  @override
  Future recommendMovie(
      {@required String uid,
      @required String movieID,
      @required String movieName}) async {
    try {
      return await _usersCollection
          .document(uid)
          .collection("RecommendedMovies")
          .add(
        {
          'movie_id': movieID,
          'movie_name': movieName,
          'rec_by': this.uid,
        },
        //${this.uid}$movieID
      );
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future reviewMovie(
      {@required String movieID,
      @required double rating,
      @required String comment}) async {
    try {
      return await _usersCollection
          .document(this.uid)
          .collection("ReviewList")
          .document(movieID)
          .updateData(
        {
          'movie_id': movieID,
          'rating': rating,
          'comment': comment,
        },
      ).whenComplete(() {
        print("Done");
        removeFromWatchList(movieID: movieID);
      });
    } catch (e) {
      try {
        return await _usersCollection
            .document(this.uid)
            .collection("ReviewList")
            .document(movieID)
            .setData(
          {
            'movie_id': movieID,
            'rating': rating,
            'comment': comment,
          },
        ).whenComplete(() {
          print('Done');
          removeFromWatchList(movieID: movieID);
        });
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future unFollow(uid) async {
    try {
      await _usersCollection
          .document(uid)
          .collection("Followers")
          .document(this.uid)
          .delete();
      await _usersCollection
          .document(this.uid)
          .collection("Following")
          .document(uid)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<UserDetails> getUserInfo() async {
    return getFriendInfo(uid: this.uid);
  }

  UserDetails _toUserDetails(DocumentSnapshot documentSnapshot) {
    try {
      return UserDetails(
        user_id: documentSnapshot.documentID,
        name: documentSnapshot.data["name"],
        user_name: documentSnapshot.data["user_name"],
        email: documentSnapshot.data["email"],
        favorite_category: documentSnapshot.data["favourite_category"],
        favorite_movie: documentSnapshot.data["favourite_movie"],
        dob: documentSnapshot.data["dob"],
        num_followers: documentSnapshot.data["num_followers"] ?? 0,
        num_following: documentSnapshot.data["num_following"] ?? 0,
        photo_profile: documentSnapshot.data["photo_profile"],
        isChatting: documentSnapshot.data['isChattingwith'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<FollowerDetails>> getFollowers() async {
    List<FollowerDetails> details = [];
    QuerySnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Followers")
        .getDocuments();
    snap.documents.forEach((DocumentSnapshot snapShot) {
      details.add(FollowerDetails(
          user_id: snapShot.data['user_id'],
          accepted: snapShot.data['accepted'] ?? false));
    });
    return details;
  }

  @override
  Future<List<FollowerDetails>> getFollowing() async {
    List<FollowerDetails> details = [];
    QuerySnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Following")
        .getDocuments();
    snap.documents.forEach((DocumentSnapshot snapShot) {
      details.add(FollowerDetails(
          user_id: snapShot.data['user_id'],
          accepted: snapShot.data['accepted'] ?? false));
    });
    return details;
  }

  @override
  Future<MovieDetails> getMovieDetails({@required String id}) async {
    dynamic response =
        await http.post("http://www.omdbapi.com/?i=$id&apikey=80246e40");
    var data = json.decode(response.body);
    return MovieDetails(
      actors: data["Actors"].split(","),
      directors: data["Director"].split(","),
      genres: data["Genre"].split(","),
      synopsis: data["Plot"],
      name: data["Title"],
      profileUrl: data["Poster"],
      rating: double.parse(data["imdbRating"]),
    );
  }

  @override
  Future<List<RecommendedMoviesDetails>> getRecommendations() async {
    List<RecommendedMoviesDetails> details = [];
    QuerySnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("RecommendedMovies")
        .getDocuments();
    snap.documents.forEach((DocumentSnapshot snapShot) {
      details.add(RecommendedMoviesDetails(
          movie_id: snapShot.data['movie_id'],
          movie_name: snapShot.data['movie_name'],
          rec_by: snapShot.data['rec_by']));
    });
    return details;
  }

  @override
  Future<List<ReviewDetails>> getReviewList() async {
    List<ReviewDetails> details = [];
    QuerySnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("ReviewList")
        .getDocuments();
    snap.documents.forEach((DocumentSnapshot snapShot) {
      details.add(ReviewDetails(
          movie_id: snapShot.data['movie_id'],
          rating: snapShot.data['rating'] ?? 0.0,
          comment: snapShot.data['comment']));
    });
    return details;
  }

  @override
  Future<UserDetails> getFriendInfo({@required String uid}) async {
    DocumentSnapshot user = await _usersCollection.document(uid).get();
    return _toUserDetails(user);
  }

  @override
  Future<List<String>> getWatchList() async {
    List<String> details = [];
    QuerySnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("WatchList")
        .getDocuments();
    snap.documents.forEach((DocumentSnapshot snapShot) {
      details.add(snapShot["movie_id"]);
    });
    return details;
  }

  Future _upLoadImage({@required Function onData, @required File image}) async {
    try {
      StorageUploadTask uploadTask =
          _storageReference.child("${DateTime.now()}.jpeg").putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((dynamic) {
        onData(dynamic);
      });
      return taskSnapshot;
    } catch (e) {
      print(e);
      onData(null);
      return null;
    }
  }

  @override
  Future removeFromWatchList({String movieID}) {
    try {
      return _usersCollection
          .document(this.uid)
          .collection("WatchList")
          .document(movieID)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future removeRecommendation({String movieID}) async {
    QuerySnapshot snapshot = await _usersCollection
        .document(this.uid)
        .collection("RecommendedMovies")
        .where("movie_id", isEqualTo: movieID)
        .getDocuments();
    snapshot.documents.forEach((DocumentSnapshot snap) async {
      await _usersCollection
          .document(this.uid)
          .collection("RecommendedMovies")
          .document(snap.documentID)
          .delete();
    });
  }

  @override
  Future<List<Map<String, String>>> getPersonSuggestion(
      String suggestion) async {
    List<Map<String, String>> toReturn = [];
    QuerySnapshot querySnapshot = await _usersCollection
        .where("search_param", arrayContains: suggestion)
        .getDocuments();
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      toReturn.add({
        'uid': documentSnapshot.documentID,
        'user_name': documentSnapshot.data['user_name'],
      });
    });
    return toReturn;
  }

  Future setUserSearch() async {
    QuerySnapshot snap = await _usersCollection.getDocuments();
    snap.documents.forEach((DocumentSnapshot snapShot) {
      try {
        _usersCollection.document(snapShot.documentID).updateData(
            {'search_param': _setSearchParam(snapShot.data['user_name'])});
      } catch (e) {}
    });
  }

  @override
  Future<bool> isFollowing({String uid}) async {
    DocumentSnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Following")
        .document(uid)
        .get();
    if (snap == null) return false;

    if (snap.exists) if (snap.data['accepted']) return true;

    return false;
  }

  @override
  Future<bool> isFollower({String uid}) async {
    DocumentSnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Followers")
        .document(uid)
        .get();
    if (snap == null) return false;

    if (snap.exists) if (snap.data['accepted']) return true;

    return false;
  }

  @override
  Future sendMessage({String uid, String message}) async {
    String chatId = _getChatID(uid, this.uid);
    return await _chatsCollection.document(chatId).collection("Messages").add(
      {
        'sender_id': this.uid,
        'reciever_id': uid,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
      },
    );
  }

  static String _getChatID(String id, String id2) {
    if (id.compareTo(id2) <= 0)
      return "$id-$id2";
    else
      return "$id2-$id";
  }

  @override
  Stream<QuerySnapshot> getMessages({String uid}) {
    String chatId = _getChatID(uid, this.uid);
    return _chatsCollection
        .document(chatId)
        .collection("Messages")
        .orderBy('timestamp', descending: false)
        .limit(20)
        .snapshots();
  }

  @override
  Future addNewChatPerson({String uid}) async {
    List p = [uid];
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'isChattingwith': FieldValue.arrayUnion(p)},
      ).whenComplete(() async {
        try {
          await _usersCollection.document(uid).updateData(
              {'isChattingwith': FieldValue.arrayUnion([this.uid])});
        }catch (e) {
          await _usersCollection.document(uid).setData(
              {'isChattingwith': FieldValue.arrayUnion([this.uid])});
        }
      });
    } catch (e) {
      return await _usersCollection.document(this.uid).setData(
        {'isChattingwith': FieldValue.arrayUnion(p)},
      ).whenComplete(() async {
        try {
          await _usersCollection.document(uid).updateData(
              {'isChattingwith': FieldValue.arrayUnion([this.uid])});
        }catch (e) {
          await _usersCollection.document(uid).setData(
              {'isChattingwith': FieldValue.arrayUnion([this.uid])});
        }
      });
    }
  }
}
