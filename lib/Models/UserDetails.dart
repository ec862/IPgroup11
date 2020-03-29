class UserDetails {
  String user_id = null;
  String name = null;
  String user_name = null;
  String email = null;
  String favorite_category = null;
  String favorite_movie = null;
  dynamic dob = DateTime.now();
  String photo_profile = null;
  int num_followers = 0;
  int num_following = 0;
  List<dynamic> isChatting;
  String gender = null;
  bool is_private;

  UserDetails({
    this.user_id,
    this.name,
    this.user_name,
    this.email,
    this.favorite_category,
    this.favorite_movie,
    this.dob,
    this.num_followers,
    this.num_following,
    this.photo_profile,
    this.isChatting,
    this.gender,
    this.is_private = true,
  });
}

class FollowerDetails{
  String user_id = "";
  bool accepted = false;
  FollowerDetails({this.user_id, this.accepted});
}

