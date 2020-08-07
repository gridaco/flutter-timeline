import 'package:flutter/material.dart';
import 'package:flutter_timeline/timeline.dart';

class CmsCommentsDemoScreen extends StatefulWidget {
  static const routeName = "/demo/cms-comments";

  @override
  State<StatefulWidget> createState() => _CmsCommentsDemoScreenState();
}

class _CmsCommentsDemoScreenState extends State<CmsCommentsDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("order #3341"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.timeline),
              SizedBox(
                width: 8,
              ),
              Text(
                "timeline",
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
        buildTimeline()
      ],
    );
  }

  Widget buildTimeline() {
    return Timeline(events: []);
  }
}
