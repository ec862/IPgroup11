import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template/CustomView/BottomBar.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  var rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Rate and Review'),
        ),
      ),
      //*******START OF NON-TEMPLATE***************
      body: createReviewPage(),

      // **********END OF NON-TEMPLATE************

      bottomNavigationBar: BottomBar().createBar(context, 0),
    );
  }

  ListView createReviewPage() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            "ADD A RATING",
            style: TextStyle(fontSize: 22), textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.center,
          child: SmoothStarRating(
            allowHalfRating: true,
            starCount: 5,
            rating: rating,
            size: 40.0,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            color: Colors.yellow[600],
            borderColor: Colors.yellow[600],
            spacing:0.0,
            onRatingChanged: (v) {
              rating = v;
              setState(() {});
            },
          )
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text(
            "ADD A REVIEW",
            style: TextStyle(fontSize: 22), textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          )
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text("Done"),
              color: Color(0xFF4B9DFE),
              textColor: Colors.white,
              padding: EdgeInsets.only(
              left: 38, right: 38, top: 15, bottom: 15),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
              onPressed: () {}
            ),
          ),
        ),
      ],
    );
  }
}
