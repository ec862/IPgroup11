import 'package:flutter/material.dart';
import 'package:template/Models/User.dart';
import 'package:template/Screens/SearchTab/searchpage.dart';
import 'package:template/Screens/main.dart';
import 'package:template/Services/DatabaseServices.dart';

const Color BOTTOM_BAR_COLOR = Colors.black;

class BottomBar {
  int currentindex = 0;

  BottomNavigationBar createBar(BuildContext context, int currentIndex) {
    this.currentindex = currentIndex;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30.0,
      selectedFontSize: 0.0,
      backgroundColor: BOTTOM_BAR_COLOR,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white,
      currentIndex: currentindex,
      onTap: (index) {
        // change when login stuff done
        if (index == 0) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        } else if (index == 1) {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(),
          );
        } else if (index != currentIndex &&
            index < Routes.bottomRoutes.length) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.bottomRoutes[index],
            ModalRoute.withName('/'),
          );
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          backgroundColor: BOTTOM_BAR_COLOR,
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          backgroundColor: BOTTOM_BAR_COLOR,
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_filter),
          backgroundColor: BOTTOM_BAR_COLOR,
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_movies),
          backgroundColor: BOTTOM_BAR_COLOR,
          title: Text(''),
        ),
        BottomNavigationBarItem(
          icon: new Stack(
            children: <Widget>[
              Icon(Icons.person),
              FutureBuilder(
                future: getFriendReqNumb(),
                builder: (context, projectSnap) {
                  if (!projectSnap.hasError &&
                      projectSnap.connectionState == ConnectionState.done &&
                      projectSnap.data != null &&
                      projectSnap.data != 0 && currentIndex != 4) {
                    return Positioned(
                      right: -3,
                      top: -6,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.all(2.9),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.deepOrange),
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                projectSnap.data.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    );
                  }
                  else {
                    return SizedBox(width: 1);
                  }
                },
              ),
            ],
          ),
          backgroundColor: BOTTOM_BAR_COLOR,
          title: Text(''),
        ),
      ],
    );
  }
}

Future getFriendReqNumb() async {
  int reqNumb = await DatabaseServices(User.userdata.uid).getFriendReqNumb();
  return reqNumb;
}

//Icon(Icons.person)
