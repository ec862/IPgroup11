import 'package:flutter/material.dart';
import 'package:template/main.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class BottomBar {
  int currentindex = 0;

  BottomNavigationBar createBar(BuildContext context, int currentIndex) {
    this.currentindex = currentIndex;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30.0,
      selectedFontSize: 0.0,
      backgroundColor: BOTTOM_BAR_COLOR,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      currentIndex: currentindex,
      onTap: (index) {
        if (index != currentIndex && index < Routes.bottomRoutes.length) {
          Navigator.pushNamed(context, Routes.bottomRoutes[index]);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: BOTTOM_BAR_COLOR,
            title: Text('')),
        BottomNavigationBarItem(
            icon: Icon(Icons.search),
            backgroundColor: BOTTOM_BAR_COLOR,
            title: Text('')),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_movies),
            backgroundColor: BOTTOM_BAR_COLOR,
            title: Text('')),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            backgroundColor: BOTTOM_BAR_COLOR,
            title: Text('')),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: BOTTOM_BAR_COLOR,
            title: Text('')),
      ],
    );
  }
}
