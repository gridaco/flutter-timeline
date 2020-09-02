import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/event_item.dart';
import 'package:flutter_timeline/timeline_theme.dart';
import 'package:flutter_timeline/timeline_theme_data.dart';

import 'indicator_position.dart';

class Timeline extends StatelessWidget {
  const Timeline(
      {@required this.events,
      this.isLeftAligned = true,
      this.padding = const EdgeInsets.all(8),
      this.controller,
      this.physics,
      this.shrinkWrap = true,
      this.primary = false,
      this.reverse = false,
      this.indicatorSize = 12.0,
      // item gap will be ignored when custom separatorBuilder is provided
      this.separatorBuilder,
      this.altOffset = const Offset(0, 0),
      this.indicatorPosition = IndicatorPosition.center})
      : itemCount = events.length;

  final Offset altOffset;
  final List<TimelineEventDisplay> events;
  final double indicatorSize;
  final bool isLeftAligned;
  final EdgeInsets padding;
  final ScrollController controller;
  final int itemCount;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final bool primary;
  final bool reverse;

  /// [indicatorPosition] describes where the indicator drawing should start. use it with alt offset
  final IndicatorPosition indicatorPosition;

  final IndexedWidgetBuilder separatorBuilder;

  @override
  Widget build(BuildContext context) {
    final TimelineThemeData timelineTheme = TimelineTheme.of(context);

    return ListView.separated(
      padding: padding,
      separatorBuilder: separatorBuilder ??
          (_, __) => SizedBox(height: timelineTheme.itemGap),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      controller: controller,
      reverse: reverse,
      primary: primary,
      itemBuilder: (context, index) {
        final event = events[index];
        // safely get prev, next events
        TimelineEventDisplay prevEvent;
        TimelineEventDisplay nextEvent;
        if (index != 0) {
          prevEvent = events[index - 1];
        }
        if (index != events.length - 1) {
          nextEvent = events[index + 1];
        }
        final isFirst = index == 0;
        final isLast = index == itemCount - 1;
        final timelineTile = <Widget>[
          if (event.hasIndicator)
            _buildIndicatorSection(
                isFirst: isFirst,
                isLast: isLast,
                prevHasIndicator: _eventHasIndicator(prevEvent),
                nextHasIndicator: _eventHasIndicator(nextEvent),
                event: event,
                theme: timelineTheme),
          if (event.hasIndicator) SizedBox(width: timelineTheme.gutterSpacing),
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

  bool _eventHasIndicator(TimelineEventDisplay event) {
    if (event == null) {
      return false;
    }
    return event.hasIndicator;
  }

  Widget buildWrappedIndicator(Widget child, {double width, double height}) {
    return Container(
      width: width,
      height: height,
      transform: Matrix4.translationValues(altOffset.dx, altOffset.dy, 0.0),
      child: child,
    );
  }

  Widget _buildIndicatorSection(
      {bool isFirst,
      bool isLast,
      bool prevHasIndicator,
      bool nextHasIndicator,
      TimelineEventDisplay event,
      TimelineThemeData theme}) {
    var overrideIndicatorSize =
        event.indicatorSize != null ? event.indicatorSize : indicatorSize;
    var overrideIndicatorPosition = event.indicatorPosition != null
        ? event.indicatorPosition
        : indicatorPosition;

    var line = CustomPaint(
      painter: _LineIndicatorPainter(
        hideDefaultIndicator: event.child != null,
        lineColor: theme.lineColor,
        indicatorSize: overrideIndicatorSize,
        maxIndicatorSize: indicatorSize,
        isFirst: isFirst,
        isLast: isLast,
        lineGap: theme.lineGap,
        strokeCap: theme.strokeCap,
        strokeWidth: theme.strokeWidth,
        style: theme.style,
        itemGap: theme.itemGap,
        altOffset: altOffset,
        prevHasIndicator: prevHasIndicator,
        nextHasIndicator: nextHasIndicator,
        indicatorPosition: overrideIndicatorPosition,
      ),
      child: SizedBox(height: double.infinity, width: indicatorSize),
    );
    return Stack(
      children: [
        line,
        Positioned.fill(
          child: Align(
              alignment: overrideIndicatorPosition.asAlignment,
              child: buildWrappedIndicator(
                event.indicator,
                width: overrideIndicatorSize,
                height: overrideIndicatorSize,
              )),
        ),
      ],
    );
  }
}

class _LineIndicatorPainter extends CustomPainter {
  _LineIndicatorPainter(
      {@required this.hideDefaultIndicator,
      @required this.indicatorSize,
      @required this.altOffset,
      @required this.maxIndicatorSize,
      @required this.lineGap,
      @required this.strokeCap,
      @required this.strokeWidth,
      @required this.style,
      @required this.lineColor,
      @required this.isFirst,
      @required this.isLast,
      @required this.nextHasIndicator,
      @required this.prevHasIndicator,
      @required this.itemGap,
      @required this.indicatorPosition})
      : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = strokeCap
          ..strokeWidth = strokeWidth
          ..style = style;

  final Offset altOffset;
  final bool hideDefaultIndicator;
  final double indicatorSize;
  final double maxIndicatorSize;
  final double lineGap;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final Color lineColor;
  final Paint linePaint;
  final bool isFirst;
  final bool isLast;
  final bool nextHasIndicator;
  final bool prevHasIndicator;
  final double itemGap;
  final IndicatorPosition indicatorPosition;

  double get altX {
    return altOffset.dx;
  }

  double get altY {
    return altOffset.dy;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // indicator's radius
    final radius = indicatorSize / 2;
    final indicatorMargin = radius + lineGap;
    final safeItemGap = radius + itemGap;
    final height = size.height;
    final halfHeight = height / 2;
    final safeHalfHeight = halfHeight - radius;
    final double halfItemGap = itemGap / 2;
    double topStartY = 0.0;

    // region override top, bottom calculator for filling empty space between events
    double overrideOffsetYForTop = altY;
    double overrideOffsetYForBottom = altY;

    if (!prevHasIndicator) {
      overrideOffsetYForTop = 0.0;
    }
    if (!nextHasIndicator) {
      overrideOffsetYForBottom = 0.0;
    }
    // endregion

    final inboundTop = size.topCenter(Offset.zero);
    final outboundTop = inboundTop.translate(
        altX, topStartY - safeItemGap + overrideOffsetYForTop);
//    final outboundTop = size.topLeft(Offset(maxIndicatorRadius + altX,
//        topStartY - safeItemGap + overrideOffsetYForTop));

    // region center
    // FIXME
    final center = size.center(Offset.zero);
    final topOfCenter = center.translate(altX, -indicatorMargin + altY);
    final bottomOfCenter = center.translate(altX, indicatorMargin + altY);
    // endregion
    final inboundBottom = size.bottomCenter(Offset.zero);
    final outboundBottom =
        inboundBottom.translate(altX, safeItemGap + overrideOffsetYForBottom);

    // region calculate starting point
/*
    switch (indicatorPosition) {
      case IndicatorPosition.top:
        topStartY = -size.height / 2;
        break;
      case IndicatorPosition.center:
        topStartY = 0;
        break;
      case IndicatorPosition.bottom:
        //        startY = size.height / 2;
        break;
    }*/
    // endregion

    // if not first, draw top-to-center  upper line
    if (!isFirst) canvas.drawLine(outboundTop, topOfCenter, linePaint);
    // if not last, draw center-to-bottom bottom line
    if (!isLast) canvas.drawLine(bottomOfCenter, outboundBottom, linePaint);
  }

  Offset upperTopStart(
      {@required IndicatorPosition indicatorPosition,
      Offset alt = const Offset(0, 0),
      bool hasPrev = true}) {}

  Offset upperBottomEnd(
      {@required IndicatorPosition indicatorPosition,
      Offset alt = const Offset(0, 0),
      bool hasPrev = true}) {}

  drawDownerLine(
      {@required IndicatorPosition indicatorPosition,
      Offset alt = const Offset(0, 0),
      bool hasNext = true}) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}



// painter v2
/*

    var testLinePaint = Paint()
      ..color = Colors.red
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth
      ..style = style;

    // initial start point
    Offset startPoint;
    switch (indicatorPosition) {
      case IndicatorPosition.top:
        startPoint = size.topCenter(Offset(0, radius));
        break;
      case IndicatorPosition.center:
        startPoint = size.center(Offset.zero);
        break;
      case IndicatorPosition.bottom:
        startPoint = size.bottomCenter(Offset(0, -radius));
        break;
    }

    // alt start point
    double additionalTopY = 0;
    if (!prevHasIndicator) additionalTopY = -itemGap;
    Offset altStartPoint = startPoint.translate(altX, altY);

    Offset topStart;
    switch (indicatorPosition) {
      case IndicatorPosition.top:
        topStart = altStartPoint.translate(
            0,
            -(safeHalfHeight + halfItemGap + indicatorMargin - lineGap) +
                additionalTopY);
        break;
      case IndicatorPosition.center:
        topStart = altStartPoint - Offset(0, lineGap);
        break;
      case IndicatorPosition.bottom:
        topStart = altStartPoint.translate(
            0,
            -(safeHalfHeight + halfItemGap + indicatorMargin - lineGap) +
                additionalTopY);
        break;
    }

    Offset topEnd = altStartPoint.translate(0, -indicatorMargin);

    // draw upper line
    if (!isFirst) canvas.drawLine(topStart, topEnd, linePaint);

    Offset bottomStart = altStartPoint.translate(
        0, (safeHalfHeight + halfItemGap + indicatorMargin - lineGap));
    Offset bottomEnd = altStartPoint.translate(0, indicatorMargin);

//    if (!isLast) canvas.drawLine(bottomStart, bottomEnd, testLinePaint);

 */

