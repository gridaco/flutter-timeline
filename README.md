# flutter_timeline [![](https://img.shields.io/badge/pub-latest-brightgreen)](https://pub.dev/packages/flutter_timeline)





![logo](doc/images/logo.png)

> a fully customizable & general timeline widget, based on real-world application references

- ✅  fully customizable indicator dot
- ✅  support spacing between indicator dot and lines
- ✅  support spacing between event (items) but leaving the line connected
- ✅  uses custom paint, but yet, indicator and body are fully customizable.
- ✅  2 real-world demos
- ✅  L2R support
- ✅  anchor support
- ✅  global offset support
- ✅  item offset support
- ✅  supported & used by [enterprise](https://github.com/genoplan), constantly updated, used on production application.


## Installation
```yaml
dependencies:
  flutter_timeline: latest
```


## usage

*simple*
```dart
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
    return TimelineTheme(
        data: TimelineThemeData(lineColor: Colors.blueAccent),
        child: Timeline(
          indicatorSize: 56,
          events: events,
        ));
  }

  void _addEvent() {
    setState(() {
      events.add(plainEventDisplay);
    });
  }
```

*using offset*
```dart
Widget _buildTimeline() {
  return Timeline(
      indicatorSize: 56,
      events: events,
      altOffset: Offset(0, -24) // set offset
  );
}
```


## references
https://www.pinterest.com/official_softmarshmallow/flutter-timeline/


## simple example [(run it now!)](https://softmarshmallow.github.io/flutter-timeline/)
![demo app](doc/images/mac-ss.png)
![demo app](doc/images/mac-ss-2.png)
![demo app](doc/images/mac-ss-3.png)

more documentation available at [github](https://github.com/softmarshmallow/flutter-timeline)


## Also check out...
[flutter_layouts](https://github.com/softmarshmallow/flutter-layouts)
