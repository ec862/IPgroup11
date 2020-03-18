class User{
  String uid;
  bool firstLogIn;

  static final User _instance = User._internal();

  factory User() => _instance;

  User._internal();

  static User get userdata => _instance;
}