# flutter_timeline

![logo](docs/images/logo.png)

> a fully customizable & general timeline widget, based on real-world application references

## Installation
```yaml
dependencies:
  flutter_timeline: latest
```


## usage
```dart

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

```

## references
https://www.pinterest.com/official_softmarshmallow/flutter-timeline/


## simple example
![demo app](./docs/images/mac-ss.png)
![demo app](./docs/images/mac-ss-2.png)
![demo app](./docs/images/mac-ss-3.png)

more documentation available at [github](https://github.com/softmarshmallow/flutter-timeline)