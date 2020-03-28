class MovieScreenArguments{
  String id = "";
  String uid = "";
  MovieScreenArguments({String id = "tt4154796", String uid}){
    this.id = id;
    this.uid = uid;
  }
}

class OtherProfileArgument{
  String id = "";
  String userName = "";
  OtherProfileArgument({this.id, this.userName});
}

class ChatMessagesArgument{
  String id;
  ChatMessagesArgument({this.id});
}