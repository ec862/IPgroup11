import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:template/CustomView/ExpandableText.dart';

class CommentView extends StatefulWidget {
  final String image;
  final String name;
  final int rating;
  final String text;

  CommentView(
      {@required this.image,
      @required this.name,
      @required this.rating,
      @required this.text});

  _CommentView createState() => _CommentView();
}

class _CommentView extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SmoothStarRating(
                    rating: widget.rating.toDouble(),
                    color: Colors.yellow[600],
                    borderColor: Colors.yellow[600],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ExpandableText(
            text: widget.text,
            limit: 100,
          ),
        )
      ],
    );
  }
}
