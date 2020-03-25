import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Screens/CheckRecommendations/RecommendMovie.dart';
import 'package:template/Screens/CheckRecommendations/ReviewScreen.dart';
import '../../CustomView/watch_card.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Models/User.dart';

const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class WatchList extends StatefulWidget {
  final uid;
  final index;

  WatchList({@required this.uid, @required this.index});
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  Future<List<String>> watchlist;
  Future<List<ReviewDetails>> reviewlist;

  @override
  Widget build(BuildContext context) {
    watchlist = DatabaseServices(widget.uid).getWatchList();
    reviewlist = DatabaseServices(widget.uid).getReviewList();
    bool isUser = (widget.uid == User.userdata.uid);

    return DefaultTabController(
      initialIndex: widget.index,
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
          title: Text(''),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.of(context).pushNamed('/chats');
              },
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            //watchlist tab
            FutureBuilder(
              future: watchlist,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                    child: Center(
                      child: Text("Nothing"),
                    ),
                  );
                List<String> content = snapshot.data;
                if (snapshot.data == null)
                  return Container(
                    child: Center(
                      child: Text("Nothing"),
                    ),
                  );

                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: new EdgeInsets.all(6.0),
                  itemCount: content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WatchCard(
                      movieID: content[index],
                      isReview: false,
                      isUser: isUser,
                    );
                  },
                );
              },
            ),

            //review history tab
            FutureBuilder(
              future: reviewlist,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) return new Container();
                List<ReviewDetails> content = snapshot.data;
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: new EdgeInsets.all(6.0),
                  itemCount: content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WatchCard(
                        movieID: content[index].movie_id,
                        isReview: true,
                        rating: content[index].rating,
                        isUser: isUser,);
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: isUser ? BottomBar().createBar(context, 3) : null,
      ),
    );
  }
}

class SelectOptions extends StatelessWidget {
  final isReview;
  final id;
  final movieName;

  SelectOptions(this.id, {@required this.isReview, @required this.movieName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Options"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Recommend Movie"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return RecommendMovie(
                  movieID: id,
                  movieName: movieName,
                );
              }));
            },
          ),
          fullDivider(),
          ListTile(
            title: !isReview
                ? Text("Remove from WatchList")
                : Text("Remove Review"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: !isReview
                ? () {
              DatabaseServices(User.userdata.uid)
                  .removeFromWatchList(movieID: id);
              Fluttertoast.showToast(
                msg: "Movie deleted",
                gravity: ToastGravity.CENTER,
              );
              Navigator.of(context).pop();
            }
                : () {
              DatabaseServices(User.userdata.uid)
                  .removeFromReviewList(movieID: id);
              Fluttertoast.showToast(
                msg: "Review deleted",
                gravity: ToastGravity.CENTER,
              );
              Navigator.of(context).pop();
            },
          ),
          fullDivider(),
          ListTile(
            title: !isReview ? Text("Review") : Text(''),
            trailing: !isReview ? Icon(Icons.keyboard_arrow_right) : null,
            onTap:!isReview ? () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ReviewScreen(
                  movieID: id,
                 );
              }));
            } : () {},
          ),
        ],
      ),
    );
  }

  Widget fullDivider() {
    return Divider(
      color: Colors.black,
    );
  }
}
