import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

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

  TimelineEventDisplay get plainEventDisplay {
    return TimelineEventDisplay(
        child: TimelineEventCard(
          title: Text("just now"),
          content: Text("someone commented on your timeline ${DateTime.now()}"),
        ),
        indicator: TimelineDots.of(context).circleIcon);
  }

  List<TimelineEventDisplay> events;

  Widget _buildTimeline() {
    return Timeline(
      indicatorSize: 56,
      indicatorStyle: PaintingStyle.stroke,
      events: events,
    );
  }

  void _addEvent() {
    setState(() {
      events.add(plainEventDisplay);
    });
  }
}
