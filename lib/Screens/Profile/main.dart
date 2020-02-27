import 'package:flutter/material.dart';
import 'profile.dart';
import 'editProfile.dart';
import 'otherProfile.dart';

//void main() => runApp(Profile());
//void main() => runApp(EditProfile());
//void main() => runApp(OtherProfile());
void main() => runApp(App());

class App extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Title',
      initialRoute: Routes.bottomRoutes[0],
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        Routes.bottomRoutes[0]: (BuildContext context) => new Profile(),
        Routes.bottomRoutes[1]: (BuildContext context) => new EditProfile(),
        '/OtherProfile': (BuildContext context) => new OtherProfile(),
        //Routes.bottomRoutes[2]: (BuildContext context) => new OtherProfile(),
      },
    );
  }
}

class Routes{
  static final bottomRoutes = ['/', 'otherProfile'];
}