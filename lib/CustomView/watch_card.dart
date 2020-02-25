import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class WatchCard extends StatelessWidget {

  final Function options;
  final String title;
  final String genre;
  final String date;
  final String img;
  final bool isReview;
  final double rating;
  WatchCard({ this.options, this.title, this.genre, this.date, this.img, @required this.isReview, this.rating});

  String _getShorterText(String text) {
    String toReturn = text;
    int maxLen = 18;
    if (text.length >= maxLen) {
      toReturn = toReturn.substring(0, maxLen);
      toReturn += " ...";
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container( // --- Movie Poster ---
                      width: MediaQuery.of(context).size.width /6,
                      height: MediaQuery.of(context).size.width/4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                    IconButton( // --- Options Button ---
                      onPressed: options,
                      icon: Icon(Icons.more_horiz, color: Colors.grey,),
                    ),
                  ],
                ),
                SizedBox(width: 16.0,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text( // --- Title Text ---
                        "${_getShorterText(title)}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[600]
                        ),
                      ),
                      SizedBox(height: 6.0,),
                      Text( // --- Genre Text ---
                        genre,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      isReview ? SmoothStarRating( // --- Star Rating ---
                          allowHalfRating: false,
                          onRatingChanged: (v) {},
                          starCount: 5,
                          rating: rating,
                          size: 30.0,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          color: Colors.green,
                          borderColor: Colors.green,
                          spacing:0.0
                      ): Text("") ,
                    ]
                ),
              ],
            ),
            SizedBox(width: 4.0,),
            IconButton( // --- Show Movie Button ---
              onPressed: (){
                Navigator.pushNamed(context, '/moviepage');
              },
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey,),
            ),
          ],
        ),
      ),
    );
  }
}