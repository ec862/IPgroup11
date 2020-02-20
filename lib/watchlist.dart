import 'package:flutter/material.dart';
import 'package:template/BottomBar.dart';
import 'watch_card.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class WatchList extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  int currentindex = 0; // home = 0

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Watch List",
              ),
              Tab(
                text: "Review History",
              )
            ],
          ),
          backgroundColor: Colors.blue[900],
          title: Text('My WatchList'),
        ),
        body: TabBarView(
          children: <Widget>[
            //watchlist tab
            ListView(
              children: <Widget>[
                WatchCard(
                  isReview: false,
                  options: () {},
                  title: "Shrek",
                  genre: "Romance",
                  date: "20/04/19",
                  img:
                      "https://img1.looper.com/img/gallery/things-only-adults-notice-in-shrek/intro-1573597941.jpg",
                ),
                WatchCard(
                  isReview: false,
                  options: () {},
                  title: "Get Out",
                  genre: "Horror",
                  date: "13/08/19",
                  img:
                      "https://m.media-amazon.com/images/M/MV5BMjUxMDQwNjcyNl5BMl5BanBnXkFtZTgwNzcwMzc0MTI@._V1_.jpg",
                ),
                WatchCard(
                  isReview: false,
                  options: () {},
                  title: "Avengers: End Game",
                  genre: "Action",
                  date: "04/01/20",
                  img:
                      "https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg",
                ),
              ],
            ),

            //review history tab
            ListView(
              children: <Widget>[
                WatchCard(
                  isReview: true,
                    options: () {},
                    title: "Shrek",
                    genre: "Romance",
                    rating: 4.0,
                    img:
                        "https://img1.looper.com/img/gallery/things-only-adults-notice-in-shrek/intro-1573597941.jpg"),
                WatchCard(
                  isReview: true,
                  options: () {},
                  title: "Get Out",
                  genre: "Horror",
                  rating: 2.0,
                  img:
                      "https://m.media-amazon.com/images/M/MV5BMjUxMDQwNjcyNl5BMl5BanBnXkFtZTgwNzcwMzc0MTI@._V1_.jpg",
                ),
                WatchCard(
                  isReview: true,
                  options: () {},
                  title: "Avengers: End Game",
                  genre: "Action",
                  rating: 5.0,
                  img:
                      "https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg",
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomBar().createBar(context, 3),
      ),
    );
  }
}
