import 'package:flutter/material.dart';
import 'package:template/Screens/SearchTab/searchpage.dart';
import 'package:template/Screens/main.dart';

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
        if (index == 0){
          Navigator.popUntil(context, ModalRoute.withName('/'));
          return;
        }
        else if (index == 1) {
          showSearch(context: context, delegate: CustomSearchDelegate(),);
        }
        else if (index != currentIndex && index < Routes.bottomRoutes.length) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.bottomRoutes[index],
            ModalRoute.withName('/'),
          );
        }
      },
      items: const <BottomNavigationBarItem>[
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
          icon: Icon(Icons.person),
          backgroundColor: BOTTOM_BAR_COLOR,
          title: Text(''),
        ),
      ],
    );
  }
}
