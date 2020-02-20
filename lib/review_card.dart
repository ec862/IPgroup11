import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewCard extends StatelessWidget {

  final Function viewMovie;
  final Function options;
  final String title;
  final String genre;
  final double rating;
  final String img;
  ReviewCard({this.viewMovie, this.options, this.title, this.genre, this.rating, this.img});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(img),
                  radius: 40.0,
                ),
                IconButton(
                  onPressed: options,
                  icon: Icon(Icons.more_horiz, color: Colors.grey,),
                ),
              ],
            ),
            SizedBox(width: 4.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[600]
                  ),
                ),
                SizedBox(height: 6.0,),
                Text(
                  genre,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8.0,),
                SmoothStarRating(
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
                )
              ],
            ),
            SizedBox(width: 4.0,),
            IconButton(
              onPressed: viewMovie,
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey,),
            ),
          ],
        ),
      ),
    );
  }
}