import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:template/Models/MovieDetails.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Models/UserDetails.dart';

abstract class BaseDatabase {
  // set details

  Future setFriendRequests({@required int number});

  Future setFirstTimeLogIn({bool state});

  Future<bool> isFirstTimeLogin();

  Future setUsername({@required String username});

  Future setName({@required String name});

  // not implemented yet
  Future setEmail({@required String email});

  Future setFavCategory({@required String category});

  Future setFavMovie({@required String movieName});

  Future setDOB({@required DateTime date});

  Future setProfilePhoto({@required File image});

  Future setGender({String gender});

  /// actions to perform
  Future follow(uid);

  Future acceptFollowing(uid);

  Future declineFollowing(uid);

  Future unFollow(uid);

  Future addToWatchList({@required String movieID, @required String movieName});

  Future removeFromWatchList({@required String movieID});

  Future removeFromReviewList({@required String movieID});

  Future removeRecommendation({String movieID});

  Future reviewMovie({@required String movieID,
    @required double rating,
    @required String comment});

  Future recommendMovie({@required String uid,
    @required String movieID,
    @required String movieName});

  Future<bool> isFollowing({@required String uid});

  Future<FollowerDetails> getFollower({@required String uid});

  Future<bool> isFollower({@required String uid});

  Future<bool> isFriend({String uid});

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

  Stream<UserDetails> get userStream;

  Future<ReviewDetails> getSingleReview({String movieID});

  Future<List<FollowerDetails>> getFriends();

  Future removeFriend({String uid});

  Future addFriend(String uid);

  Future<List<ReviewDetails>> getFriendReview({String movieID});

  Future setFriendRequests({@required int number});

  Future blockUser({@required String theirUID});

  Future unBlockUser({@required String theirUID});

  Future checkYouBlocked({@required String theirUID});

  Future checkBlockedBy({@required String theirUID});
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

    List<String> t = caseNumber.split('_');
    for (int i = 0; i < t.length; i++) {
      caseSearchList.add(t[i]);
    }
    t = caseNumber.split('-');
    for (int i = 0; i < t.length; i++) {
      caseSearchList.add(t[i]);
    }
    t = caseNumber.split('.');
    for (int i = 0; i < t.length; i++) {
      caseSearchList.add(t[i]);
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
          'timestamp': DateTime.now()
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
            'timestamp': DateTime.now()
          },
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future follow(uid) async {
    bool blocked = await checkBlockedBy(theirUID: uid);
    if (blocked) {
      return false;
    }
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
        ).whenComplete(() async {
          await setFriendRequests(number: 1, theirUID: uid);
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
        await setFriendRequests(number: -1, theirUID: this.uid);

        _addToFollowing(uid, accepted: true);
        // check if you're following them to can add as friends
        if (await isFollowing(uid: uid)) addFriend(uid);
      });
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  @override
  Future removeFollowing(uid) async {
    DocumentSnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Followers")
        .document(uid)
        .get();
    bool accepted = snap.data['accepted'];
    if (snap.exists && !accepted) {
      setFriendRequests(number: -1, theirUID: this.uid);
    }
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

  @override
  Future declineFollowing(uid) async {
    removeFollowing(uid);
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
          .document("${this.uid}$movieID")
          .setData(
        {
          'movie_id': movieID,
          'movie_name': movieName,
          'rec_by': this.uid,
          'timestamp': DateTime.now(),
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
      DocumentSnapshot snap = await _usersCollection
          .document(uid)
          .collection("Followers")
          .document(this.uid)
          .get();
      bool accepted = snap.data['accepted'];
      if (snap.exists && !accepted) {
        setFriendRequests(number: -1, theirUID: uid);
      }
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
      await removeFriend(uid: uid);
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
        name: documentSnapshot.data["name"] ?? '',
        user_name: documentSnapshot.data["user_name"] ?? '',
        email: documentSnapshot.data["email"] ?? '',
        favorite_category: documentSnapshot.data["favourite_category"] ?? '',
        favorite_movie: documentSnapshot.data["favourite_movie"] ?? '',
        dob: documentSnapshot.data["dob"],
        num_followers: documentSnapshot.data["num_followers"] ?? 0,
        num_following: documentSnapshot.data["num_following"] ?? 0,
        photo_profile: documentSnapshot.data["photo_profile"] ?? '',
        isChatting: documentSnapshot.data['isChattingwith'],
        gender: documentSnapshot.data['gender'] ?? '',
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
        .orderBy('timestamp', descending: true)
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
        .orderBy('timestamp', descending: true)
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
  Future removeFromReviewList({String movieID}) {
    try {
      return _usersCollection
          .document(this.uid)
          .collection("ReviewList")
          .document(movieID)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future removeRecommendation(
      {String movieID, @required String recFrom}) async {
    try {
      return await _usersCollection
          .document(this.uid)
          .collection('RecommendedMovies')
          .document("$recFrom$movieID")
          .delete();
    } catch (e) {
      return null;
    }
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
        'timestamp': DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()
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
          await _usersCollection.document(uid).updateData({
            'isChattingwith': FieldValue.arrayUnion([this.uid])
          });
        } catch (e) {
          await _usersCollection.document(uid).setData({
            'isChattingwith': FieldValue.arrayUnion([this.uid])
          });
        }
      });
    } catch (e) {
      return await _usersCollection.document(this.uid).setData(
        {'isChattingwith': FieldValue.arrayUnion(p)},
      ).whenComplete(() async {
        try {
          await _usersCollection.document(uid).updateData({
            'isChattingwith': FieldValue.arrayUnion([this.uid])
          });
        } catch (e) {
          await _usersCollection.document(uid).setData({
            'isChattingwith': FieldValue.arrayUnion([this.uid])
          });
        }
      });
    }
  }

  @override
  Stream<UserDetails> get userStream {
    return _usersCollection.document(this.uid).snapshots().map(_toUserDetails);
  }

  @override
  Future setGender({String gender}) async {
    try {
      return await _usersCollection.document(this.uid).updateData(
        {'gender': gender},
      ).whenComplete(() {
        print("Done");
      });
    } catch (e) {
      try {
        return await _usersCollection.document(this.uid).setData(
          {'gender': gender},
        );
      } catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future<bool> isFirstTimeLogin() async {
    DocumentSnapshot snap = await _usersCollection.document(this.uid).get();
    if (snap.data['is_first_time'] == null) return true;
    if (snap.data['is_first_time'] == true) return true;

    return false;
  }

  @override
  Future setFirstTimeLogIn({bool state}) async {
    try {
      return await _usersCollection
          .document(this.uid)
          .updateData({'is_first_time': state});
    } catch (e) {
      return await _usersCollection
          .document(this.uid)
          .setData({'is_first_time': state});
    }
  }

  @override
  Future<ReviewDetails> getSingleReview({String movieID}) async {
    DocumentSnapshot snapshot = await _usersCollection
        .document(this.uid)
        .collection("ReviewList")
        .document(movieID)
        .get();
    if (snapshot.data != null)
      return ReviewDetails(
          movie_id: snapshot.data['movie_id'],
          rating: snapshot.data['rating'] ?? 0.0,
          comment: snapshot.data['comment']);

    return null;
  }

  @override
  Future<FollowerDetails> getFollower({String uid}) async {
    DocumentSnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Following")
        .document(uid)
        .get();
    if (snap.data == null) return null;

    return FollowerDetails(
        user_id: snap.data['user_id'],
        accepted: snap.data['accepted'] ?? false);
  }

  Future<bool> isFriend({String uid}) async {
    bool following = await isFollowing(uid: uid);
    bool follower = await isFollower(uid: uid);
    return (follower && following);
  }

  @override
  Future<List<FollowerDetails>> getFriends() async {
    List<FollowerDetails> details = [];
    QuerySnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("Friends")
        .getDocuments();

    snap.documents.forEach((DocumentSnapshot snapShot) {
      details.add(FollowerDetails(
        user_id: snapShot.data['user_id'],
      ));
    });
    return details;
  }

  @override
  Future removeFriend({String uid}) async {
    try {
      await _usersCollection
          .document(uid)
          .collection("Friends")
          .document(this.uid)
          .delete();
      await _usersCollection
          .document(this.uid)
          .collection("Friends")
          .document(uid)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future addFriend(String uid) async {
    try {
      await _usersCollection
          .document(uid)
          .collection("Friends")
          .document(this.uid)
          .setData({'user_id': this.uid});
      await _usersCollection
          .document(this.uid)
          .collection("Friends")
          .document(uid)
          .setData({'user_id': uid});
    } catch (e) {
      return null;
    }
  }

  Future<int> getFriendReqNumb() async {
    DocumentSnapshot snapshot = await _usersCollection.document(this.uid).get();
    int numb = snapshot.data['friend_requests'];
    if (numb != null && numb != 0) {
      return numb;
    } else {
      return 0;
    }
  }

  @override
  Future<List<ReviewDetails>> getFriendReview({String movieID}) async {
    List<FollowerDetails> friends = await getFriends();
    if (friends == null) return null;
    List<ReviewDetails> reviews = [];

    for (int i = 0; i < friends.length; i++) {
      QuerySnapshot snapshot = await _usersCollection
          .document(friends[i].user_id)
          .collection('ReviewList')
          .where('movie_id', isEqualTo: movieID)
          .getDocuments();
      snapshot.documents.forEach((DocumentSnapshot snap) {
        reviews.add(ReviewDetails(
          movie_id: snap.data['movie_id'],
          rating: snap.data['rating'] ?? 0.0,
          comment: snap.data['comment'],
          userId: friends[i].user_id,
        ));
      });
    }
    return reviews;
  }

  @override
  Future setFriendRequests(
      {@required int number, @required String theirUID}) async {
    try {
      if (number == -1) {
        return await _usersCollection.document(theirUID).updateData(
          {'friend_requests': FieldValue.increment(-1)},
        ).whenComplete(() {});
      }
      else if (number == 1) {
        return await _usersCollection.document(theirUID).updateData(
          {'friend_requests': FieldValue.increment(1)},
        ).whenComplete(() {});
      }
      else {
        return await _usersCollection.document(theirUID).updateData(
          {'friend_requests': number},
        ).whenComplete(() {});
      }
    }
    catch (e) {
      try {
        return await _usersCollection.document(theirUID).setData(
          {'friend_requests': 0},
        );
      }
      catch (ex) {
        print(ex);
        return null;
      }
    }
  }

  @override
  Future blockUser({@required String theirUID}) async {
    print("blocked");
    await _usersCollection
        .document(theirUID)
        .collection("BlockedBy")
        .document(this.uid)
        .setData({}).whenComplete(() {
      unFollow(theirUID);
      removeFollowing(theirUID);
    });
  }

  @override
  Future unBlockUser({@required String theirUID}) async {
    print("unblocked");
    return await _usersCollection
        .document(theirUID)
        .collection("BlockedBy")
        .document(this.uid)
        .delete();
  }

  @override
  Future checkYouBlocked({@required String theirUID}) async {
    DocumentSnapshot snap = await _usersCollection
        .document(theirUID)
        .collection("BlockedBy")
        .document(this.uid)
        .get();
    if (snap.exists && snap != null) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> checkBlockedBy({@required String theirUID}) async {
    DocumentSnapshot snap = await _usersCollection
        .document(this.uid)
        .collection("BlockedBy")
        .document(theirUID)
        .get();
    if (snap.exists && snap != null) {
      return true;
    }
    else {
      return false;
    }
  }
}
