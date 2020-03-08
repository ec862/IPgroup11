import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Screens/CheckRecommendations/CheckRecomendations.dart';
import 'package:template/Screens/SearchTab/searchpage.dart';
import 'package:template/Services/ImageServices.dart';
import '../main.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<RecommendationInfo> movies = [];

  @override
  void initState() {
    super.initState();
    movies.add(RecommendationInfo());
    movies.add(RecommendationInfo(id: "tt3896198"));
    movies.add(RecommendationInfo(id: "tt5052448"));
    movies.add(RecommendationInfo(id: "tt0848228"));
    movies.add(RecommendationInfo(id: "tt0974015"));
    movies.add(RecommendationInfo(id: "tt0369610"));
    movies.add(RecommendationInfo(id: "tt4881806"));
  }

  @override
  Widget build(BuildContext context) {
    final double headPadding = MediaQuery
        .of(context)
        .size
        .height / 100;
    final double listSize = MediaQuery.of(context).size.height / 8.1;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Home Page'),
        ),
      ),

      //*******START OF NON-TEMPLATE***************
      body: createHomePage(headPadding, listSize),

      // **********END OF NON-TEMPLATE************

      bottomNavigationBar: BottomBar().createBar(context, 0),
    );
  }

  ListView createHomePage(double headPadding, double listSize) {
    return ListView(
        children: <Widget>[
          topButtons(context, headPadding),
          Divider(
            height: 1,
          ),
          Container(
            child: Text(
              "Recent Recommendations",
              style: TextStyle(fontSize: 22), textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .width * 1.172,
            //width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) =>
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.02,
                      child: MovieContent(movies[index], 1.172)),
            ),
          ),
        ],
    );
  }

  Widget topButtons(BuildContext context, double headPadding) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(headPadding),
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            splashColor: Colors.deepOrangeAccent,
            child: Container(
                child: Text(
                  "Recommend New Movie",
                  style: TextStyle(fontSize: 25),
                )),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5)),
          ),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.bottomRoutes[2],
                  ModalRoute.withName('/'),
                );
              },
              splashColor: Colors.deepOrangeAccent,
              child: Text(
                "See All Friend Recomendations",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5))),
        ],
      ),
    );
  }
}
