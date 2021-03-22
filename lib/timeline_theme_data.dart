import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/indicator_position.dart';

/// [TimelineThemeData] is passed through [TimelineTheme], works like general flutter theme object.
class TimelineThemeData with Diagnosticable {
  TimelineThemeData({
    this.gutterSpacing = 12.0,
    this.itemGap = 24.0,
    this.lineGap = 0.0,
    this.strokeWidth = 4.0,
    this.strokeCap = StrokeCap.butt,
    this.lineColor = Colors.lightBlueAccent,
    this.style = PaintingStyle.stroke,
    this.indicatorPosition = IndicatorPosition.center,
  })  : assert(itemGap >= 0),
        assert(lineGap >= 0);

  final Color lineColor;
  final double lineGap;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final double itemGap;
  final double gutterSpacing;

  /// the position of the indicator. this affects the placing of the indicator, and following line measurement
  final IndicatorPosition indicatorPosition;

  /// Creates an timeline them with some reasonable default values.
  ///
  /// The [color] is black, the [opacity] is 1.0, and the [size] is 24.0.
  const TimelineThemeData.fallback()
      : lineColor = Colors.lightBlueAccent,
        lineGap = 0.0,
        strokeCap = StrokeCap.butt,
        strokeWidth = 4.0,
        style = PaintingStyle.stroke,
        itemGap = 24.0,
        gutterSpacing = 12.0,
        indicatorPosition = IndicatorPosition.center;

  TimelineThemeData copyWith(
      {Color? lineColor, StrokeCap? strokeCap, double? strokeWidth}) {
    return TimelineThemeData(
      lineColor: lineColor ?? this.lineColor,
      strokeCap: strokeCap ?? this.strokeCap,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  TimelineThemeData resolve(BuildContext context) => this;
}
