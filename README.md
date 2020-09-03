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





*using anchor & offset*

```dart
  TimelineEventDisplay get plainEventDisplay {
    return TimelineEventDisplay(
        anchor: IndicatorPosition.top,
        indicatorOffset: Offset(0, 24),
        child: TimelineEventCard(
          title: Text("multi\nline\ntitle\nawesome!"),
          content: Text("someone commented on your timeline ${DateTime.now()}"),
        ),
        indicator: randomIndicator);
  }
```



## references
https://www.pinterest.com/official_softmarshmallow/flutter-timeline/


## complex example

<img src="./doc/images/desk-ss-01.png" width="300"/>



## simple example [(run it now!)](https://softmarshmallow.github.io/flutter-timeline/)
<img src="./doc/images/mac-ss.png" width="500"/>
<img src="./doc/images/mac-ss-2.png" width="500"/>
<img src="./doc/images/mac-ss-3.png" width="500"/>

more documentation available at [github](https://github.com/softmarshmallow/flutter-timeline)


## Also check out...
[flutter_layouts](https://github.com/softmarshmallow/flutter-layouts)
