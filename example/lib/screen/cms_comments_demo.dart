import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

class DeskTimelineDemoScreen extends StatefulWidget {
  static const routeName = "/demo/cms-comments";

  @override
  State<StatefulWidget> createState() => _DeskTimelineDemoScreenState();
}

class _DeskTimelineDemoScreenState extends State<DeskTimelineDemoScreen> {
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
                style: Theme.of(context).textTheme.titleLarge,
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
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(color: Colors.amber),
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
