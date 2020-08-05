import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      events.add(EventDisplay(
          child: Container(height: 100, color: Colors.grey),
          indicator: TimelineDots.of(context).simple));
    });
  }

  Widget _buildBody() {
    return _buildTimeline();
  }

  List<EventDisplay> events = [
    EventDisplay(
      child: Container(height: 200, color: Colors.grey),
    ),
    EventDisplay(
      child: Container(height: 100, color: Colors.grey),
    )
  ];

  Widget _buildTimeline() {
    return Timeline(
      events: events,
    );
  }
}
