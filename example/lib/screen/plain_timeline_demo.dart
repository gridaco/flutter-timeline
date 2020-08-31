import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:flutter_timeline/indicator_position.dart';
import 'package:flutter_timeline/timeline_theme.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';

class PlainTimelineDemoScreen extends StatefulWidget {
  static const routeName = "/demo/plain";

  @override
  State<StatefulWidget> createState() => _PlainTimelineDemoScreenState();
}

class _PlainTimelineDemoScreenState extends State<PlainTimelineDemoScreen> {
  @override
  void initState() {
    super.initState();
    events = [
      smallEventDisplay,
      plainEventDisplay,
      TimelineEventDisplay(
          child: Card(
        child: TimelineEventCard(
          title: Text("click the + button"),
          content: Text("to add a new event item"),
        ),
      )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("plain timeline"),
      ),
      body: _buildTimeline(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'add new event',
        child: Icon(Icons.add),
      ),
    );
  }

  TimelineEventDisplay get smallEventDisplay {
    return TimelineEventDisplay(
        child: Card(
          child: TimelineEventCard(
            title: Text("click the + button"),
            content: Text("to add a new event item"),
          ),
        ),
        indicatorSize: 12,
        indicator: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: Colors.blueAccent),
        ));
  }

  Widget get randomIndicator {
    var candidates = [
      TimelineDots.of(context).circleIcon,
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ];
    final _random = new Random();
    var element = candidates[_random.nextInt(candidates.length)];
    return element;
  }

  TimelineEventDisplay get plainEventDisplay {
    return TimelineEventDisplay(
        child: TimelineEventCard(
          title: Text("just \n\n\n\n now"),
          content: Text("someone commented on your timeline ${DateTime.now()}"),
        ),
        indicator: randomIndicator);
  }

  List<TimelineEventDisplay> events;

  Widget _buildTimeline() {
    return TimelineTheme(
        data: TimelineThemeData(lineColor: Colors.blueAccent),
        child: Timeline(
          indicatorPosition: IndicatorPosition.top,
          altOffset: Offset(0, -24),
          indicatorSize: 56,
          events: events,
        ));
  }

  void _addEvent() {
    setState(() {
      events.add(plainEventDisplay);
    });
  }
}
