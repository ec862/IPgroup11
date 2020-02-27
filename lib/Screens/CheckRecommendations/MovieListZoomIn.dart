import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieListZoomIn extends StatelessWidget {
  final list;
  final movieName;

  MovieListZoomIn({
    @required this.list,
    @required this.movieName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$movieName"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return Text(
            list[index],
            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          );
        },
      ),
    );
  }
}
