import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
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

  _buildTodaySection() {
    return Text(
      "Today",
      style:
          Theme.of(context).textTheme.headline5.copyWith(color: Colors.amber),
    );
  }

  Widget buildTimeline() {
    return Timeline(events: [
      TimelineEventDisplay(
          child: _buildTodaySection(),
          indicator: Container(
            color: Colors.amber,
          )),
    ]);
  }
}
