import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

void main() {
  runApp(TimelineDemoApp());
}

class TimelineDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timeline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DemoHomePage(title: 'Flutter Timeline Demo'),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  DemoHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DemoHomePageState createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'add new event',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addEvent() {
    setState(() {
      events.add(TimelineEventDisplay(
          child: TimelineEventCard(
            title: Text("title"),
            content: Text("content"),
          ),
          indicator: TimelineDots.of(context).borderDot));
    });
  }

  Widget _buildBody() {
    return _buildTimeline();
  }

  List<TimelineEventDisplay> events = [
    TimelineEventDisplay(
      child: TimelineEventCard(
        title: Text("title"),
        content: Text("content"),
      ),
    ),
    TimelineEventDisplay(
      child: Container(height: 100, color: Colors.grey),
    )
  ];

  Widget _buildTimeline() {
    return Timeline(
      indicatorStyle: PaintingStyle.stroke,
      events: events,
    );
  }
}
