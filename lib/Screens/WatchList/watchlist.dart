import 'package:flutter/material.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Models/ReviewDetails.dart';
import 'package:template/Screens/CheckRecommendations/RecommendMovie.dart';
import '../../CustomView/watch_card.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Models/User.dart';


const Color BOTTOM_BAR_COLOR = Colors.redAccent;

class WatchList extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {

  Future<List<String>> watchlist = DatabaseServices(User.userdata.uid).getWatchList();
  Future<List<ReviewDetails>> reviewlist = DatabaseServices(User.userdata.uid).getReviewList();

  @override
  Widget build(BuildContext context) {
    Function options = (){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SelectOption(isReview: false);
      }));
    };
    Function optionsReview = (){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SelectOption(isReview: true);
      }));
    };
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
            FutureBuilder(
              future: watchlist,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: Text("No data"),
                    ),
                  );
                List<String> content = snapshot.data;
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: new EdgeInsets.all(6.0),
                  itemCount: content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WatchCard(movieID: content[index], isReview: false, options: options);
                  },
                );
              },
            ),

            //review history tab
            FutureBuilder(
              future: reviewlist,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot){
                if (!snapshot.hasData)
                  return new Container();
                List<ReviewDetails> content = snapshot.data;
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: new EdgeInsets.all(6.0),
                  itemCount: content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WatchCard(movieID: content[index].movie_id, isReview: true, rating: content[index].rating, options: optionsReview);
                  },
                );
              },
            ),
            /*
            ListView(
              children: <Widget>[WatchCard(movieID: "tt0848228", isReview: true, rating: 4, options: optionsReview)],
            ),
            */
          ],
        ),
        bottomNavigationBar: BottomBar().createBar(context, 3),
      ),
    );
  }
}

class SelectOption extends StatelessWidget {

  final isReview;
  SelectOption({@required this.isReview});

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
            title: !isReview ? Text("Remove from WatchList") : Text("Remove Review"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: !isReview ? () {} : () {},
          ),
          fullDivider(),
          ListTile(
            title: Text("Recommend Movie"),
            trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return RecommendMovie();
                }));
              },
          ),
          fullDivider(),
          ListTile(
            title: Text("Review"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {},
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
