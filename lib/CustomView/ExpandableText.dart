import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  int limit = 50;
  String text = "";

  ExpandableText({this.limit, this.text});

  _ExpandableText createState() => _ExpandableText();
}

class _ExpandableText extends State<ExpandableText> {
  String first = "";
  String second = "";
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > widget.limit) {
      first = widget.text.substring(0, widget.limit);
      second = widget.text.substring(widget.limit, widget.text.length);
    } else {
      first = widget.text;
      second = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: second.isEmpty
            ? Text(first)
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isExpanded ? Text(first + second) : Text(first +"..." ),
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded)
                    isExpanded = false;
                  else
                    isExpanded = true;
                });
              },
              child: isExpanded
                  ? Text(
                "Show Less",
                style: TextStyle(color: Colors.blue),
              )
                  : Text("Show More",
                  style: TextStyle(color: Colors.blue)),
            )
          ],
        ));
  }
}
