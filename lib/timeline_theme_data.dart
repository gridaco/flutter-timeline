import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class TimelineThemeData with Diagnosticable {
  TimelineThemeData({this.color});

  final Color color;

  /// Whether all the properties of this object are non-null.
  bool get isConcrete => color != null; // &&

  /// Creates an timeline them with some reasonable default values.
  ///
  /// The [color] is black, the [opacity] is 1.0, and the [size] is 24.0.
  const TimelineThemeData.fallback() : color = Colors.lightBlueAccent;

//      : color = const Color(0xFF000000),
//        _opacity = 1.0,
//        size = 24.0;

  TimelineThemeData copyWith({Color color, double opacity, double size}) {
    return TimelineThemeData(
      color: color ?? this.color,
    );
  }

  TimelineThemeData resolve(BuildContext context) => this;
}
