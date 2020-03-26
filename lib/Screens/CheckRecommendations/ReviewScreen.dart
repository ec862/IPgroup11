import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template/CustomView/BottomBar.dart';
import 'package:template/Services/DatabaseServices.dart';
import 'package:template/Models/User.dart';


class ReviewScreen extends StatefulWidget {

  final movieID;

  ReviewScreen({Key key, @required this.movieID}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var rating = 0.0;
  final myController = TextEditingController();
  bool ratingNotZero = false;

  @override
  Widget build(BuildContext context) {
    print("herrereeee");
    print(widget.movieID);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Rate and Review'),
        ),
      ),
      //*******START OF NON-TEMPLATE***************
      body: createReviewPage(context),

      // **********END OF NON-TEMPLATE************

      bottomNavigationBar: BottomBar().createBar(context, 0),
    );
  }

  ListView createReviewPage(context) {
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
              setState(() {
                rating = v;
              });
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
              controller: myController,
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
              onPressed: () async {
                print(widget.movieID);
                print("hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                if (rating < 1) {
                  _showDialog();
                  ratingNotZero = true;
                }
                else {
                  ratingNotZero = false;
                }
                if (ratingNotZero == false) {
                  if (myController.text.trim() == "") {
                    myController.text = "No comment added";
                  }
                  await DatabaseServices(User.userdata.uid)
                      .reviewMovie(movieID: widget.movieID,
                      rating: rating,
                      comment: myController.text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Oops!"),
          content: new Text("Please leave a valid rating"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
