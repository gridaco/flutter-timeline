import 'package:flutter/material.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';

/// Controls the default color, opacity, and size of timeline in a widget subtree.
/// The timeline theme is honored by [Timeline] widgets.
class TimelineTheme extends InheritedTheme {
  final TimelineThemeData data;
  final Widget child;

  /// Creates an timeline theme that controls the styles of descendant widgets.
  /// Both [data] and [child] arguments must not be null.
  const TimelineTheme({Key key, @required this.data, @required this.child})
      : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  static TimelineThemeData of(BuildContext context) {
    final TimelineThemeData timelineThemeData =
        _getInheritedTimelineThemeData(context).resolve(context);
    return timelineThemeData.isConcrete
        ? timelineThemeData
        : timelineThemeData.copyWith(
            lineColor: timelineThemeData.lineColor ??
                const TimelineThemeData.fallback().lineColor,
            strokeWidth: timelineThemeData.strokeWidth ??
                const TimelineThemeData.fallback().strokeWidth,
            strokeCap: timelineThemeData.strokeCap ??
                const TimelineThemeData.fallback().strokeCap,
          );
  }

  static TimelineThemeData _getInheritedTimelineThemeData(
      BuildContext context) {
    final TimelineTheme timelineTheme =
        context.dependOnInheritedWidgetOfExactType<TimelineTheme>();
    return timelineTheme?.data ?? const TimelineThemeData.fallback();
  }

  @override
  bool updateShouldNotify(TimelineTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final TimelineTheme timelineTheme =
        context.findAncestorWidgetOfExactType<TimelineTheme>();
    return identical(this, timelineTheme)
        ? child
        : TimelineTheme(data: data, child: child);
  }
}
