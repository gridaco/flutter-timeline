import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/event_item.dart';
import 'package:flutter_timeline/timeline_theme.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';

class Timeline extends StatelessWidget {
  const Timeline({
    @required this.events,
    this.isLeftAligned = true,
    this.padding = const EdgeInsets.all(8),
    this.controller,
    this.physics,
    this.shrinkWrap = true,
    this.primary = false,
    this.reverse = false,
    this.indicatorStyle = PaintingStyle.fill,
    this.gutterSpacing = 12.0,
    this.itemGap = 24.0,
    this.lineGap = 0.0,
    this.indicatorSize = 12.0,
    this.strokeWidth = 4.0,
    this.strokeCap = StrokeCap.butt,
    this.indicatorColor = Colors.blue,
    this.lineColor = Colors.lightBlueAccent,
    this.style = PaintingStyle.stroke,
    // item gap will be ignored when custom separatorBuilder is provided
    this.separatorBuilder,
  })  : itemCount = events.length,
        assert(itemGap >= 0),
        assert(lineGap >= 0);

  final List<TimelineEventDisplay> events;
  final double itemGap;
  final double gutterSpacing;
  final bool isLeftAligned;
  final EdgeInsets padding;
  final ScrollController controller;
  final int itemCount;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final bool primary;
  final bool reverse;

  final Color lineColor;
  final double lineGap;
  final double indicatorSize;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final IndexedWidgetBuilder separatorBuilder;

  @override
  Widget build(BuildContext context) {
    final TimelineThemeData timelineTheme = TimelineTheme.of(context);

    return ListView.separated(
      padding: padding,
      separatorBuilder:
          separatorBuilder ?? (_, __) => SizedBox(height: itemGap),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      controller: controller,
      reverse: reverse,
      primary: primary,
      itemBuilder: (context, index) {
        final event = events[index];

        Widget indicator;

        if (event.indicator != null) {
          indicator = event.indicator;
        }

        final isFirst = index == 0;
        final isLast = index == itemCount - 1;

        final timelineTile = <Widget>[
          if (event.hasIndicator)
            _buildIndicator(isFirst: isFirst, isLast: isLast, child: indicator),
          if (event.hasIndicator) SizedBox(width: gutterSpacing),
          Expanded(child: event.child),
        ];

        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
                isLeftAligned ? timelineTile : timelineTile.reversed.toList(),
          ),
        );
      },
    );
  }

  Widget _buildIndicator({bool isFirst, bool isLast, Widget child}) {
    //    return
    var line = CustomPaint(
      painter: _LineIndicatorPainter(
        hideDefaultIndicator: child != null,
        lineColor: lineColor,
//        indicatorColor: indicatorColor,
        indicatorSize: indicatorSize,
//        indicatorStyle: indicatorStyle,
        isFirst: isFirst,
        isLast: isLast,
        lineGap: lineGap,
        strokeCap: strokeCap,
        strokeWidth: strokeWidth,
        style: style,
        itemGap: itemGap,
      ),
//      size: const Size(double.infinity, double.infinity),
      child: SizedBox(height: double.infinity, width: indicatorSize),
    );
    return Stack(
      children: [
        line,
        Align(
          child: SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: child,
          ),
        )
      ],
    );
  }
}

class _LineIndicatorPainter extends CustomPainter {
  _LineIndicatorPainter({
    @required this.hideDefaultIndicator,
    @required this.indicatorSize,
    @required this.lineGap,
    @required this.strokeCap,
    @required this.strokeWidth,
    @required this.style,
    @required this.lineColor,
    @required this.isFirst,
    @required this.isLast,
    @required this.itemGap,
  }) : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = strokeCap
          ..strokeWidth = strokeWidth
          ..style = style;

  final bool hideDefaultIndicator;
  final double indicatorSize;
  final double lineGap;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final Color lineColor;
  final Paint linePaint;
  final bool isFirst;
  final bool isLast;
  final double itemGap;

  @override
  void paint(Canvas canvas, Size size) {
    final indicatorRadius = indicatorSize / 2;
    final halfItemGap = itemGap / 2;
    final indicatorMargin = indicatorRadius + lineGap;

    final top = size.topLeft(Offset(indicatorRadius, 0.0 - itemGap));
    final centerTop = size.centerLeft(
      Offset(indicatorRadius, -indicatorMargin),
    );

    final bottom = size.bottomLeft(Offset(indicatorRadius, 0.0 + halfItemGap));
    final centerBottom = size.centerLeft(
      Offset(indicatorRadius, indicatorMargin),
    );

    if (!isFirst) canvas.drawLine(top, centerTop, linePaint);
    if (!isLast) canvas.drawLine(centerBottom, bottom, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
