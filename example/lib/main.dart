import 'package:example/screen/cms_comments_demo.dart';
import 'package:example/screen/plain_timeline_demo.dart';
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
      routes: {
        PlainTimelineDemoScreen.routeName: (c) => PlainTimelineDemoScreen(),
        CmsCommentsDemoScreen.routeName: (c) => CmsCommentsDemoScreen(),
      },
      home: DemoHomePage(title: 'Flutter Timeline Demo'),
    );
  }
}

List<DemoScreen> demos = [
  DemoScreen(
      name: "plain timeline",
      description: "simplest timeline demo",
      cover: null,
      route: PlainTimelineDemoScreen.routeName),
  DemoScreen(
      name: "cms / e-commerce with comments",
      description: "demo for creating timeline such like shopify",
      cover: null,
      route: CmsCommentsDemoScreen.routeName),
  DemoScreen(
      name: "plain timeline",
      description: "simplest timeline demo",
      cover: null,
      route: PlainTimelineDemoScreen.routeName),
];

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
    );
  }

  Widget _buildDemoEntries() {
    return ListView.builder(
      itemBuilder: (c, i) {
        var data = demos[i];
        return ListTile(
          title: Text(data.name),
          subtitle: Text(data.description),
          onTap: () {
            Navigator.of(context).pushNamed(data.route);
          },
        );
      },
      itemCount: demos.length,
    );
  }

  Widget _buildBody() {
    return _buildDemoEntries();
  }
}

class DemoScreen {
  DemoScreen(
      {@required this.name,
      @required this.description,
      @required this.cover,
      @required this.route});

  final String name;
  final String description;
  final String cover;
  final String route;
}
