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
        print(index);
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

  Widget buildWrappedIndicator(Widget child,
      {double width, double height, Offset indicatorOffset}) {
    final offset = altOffset + indicatorOffset;
    return Container(
      width: width,
      height: height,
      transform: Matrix4.translationValues(offset.dx, offset.dy, 0.0),
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
    final overrideIndicatorSize =
        event.indicatorSize != null ? event.indicatorSize : indicatorSize;
    final overrideIndicatorPosition = event.indicatorPosition != null
        ? event.indicatorPosition
        : indicatorPosition;
    final indicatorOffset = event.indicatorOffset;

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
        indicatorOffset: indicatorOffset,
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
                indicatorOffset: indicatorOffset,
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
      @required this.indicatorOffset,
      @required this.indicatorPosition})
      : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = strokeCap
          ..strokeWidth = strokeWidth
          ..style = style;

  final Offset altOffset;
  final bool hideDefaultIndicator;
  final double indicatorSize;
  final Offset indicatorOffset;
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
    return altOffset.dx + indicatorOffset.dx;
  }

  double get altY {
    return altOffset.dy + indicatorOffset.dy;
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

    var testLinePaint = Paint()
      ..color = Colors.red
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth
      ..style = style;

    // initial start point
    // works well
    Offset indicatorCenterStartPoint;
    switch (indicatorPosition) {
      case IndicatorPosition.top:
        indicatorCenterStartPoint = size.topCenter(Offset(0, radius));
        break;
      case IndicatorPosition.center:
        indicatorCenterStartPoint = size.center(Offset.zero);
        break;
      case IndicatorPosition.bottom:
        indicatorCenterStartPoint = size.bottomCenter(Offset(0, -radius));
        break;
    }

    print("indicatorCenterStartPoint : $indicatorCenterStartPoint");

    // alt start point
    Offset indicatorCenter = indicatorCenterStartPoint.translate(altX, altY);
    print("indicatorCenter : $indicatorCenter");

    // region upper line
    if (!isFirst) {
      double additionalGap = 0;
      if (!prevHasIndicator) additionalGap = halfItemGap;
      final additionalTop = getAdditionalY(height);

      // works well
      Offset topStart = indicatorCenter.translate(
          0,
          // the altY + radius is the default start point.
          // adding half item gap is also by default.
          // the below two items does not get affected by the indicator position
          -(((altY + radius) + halfItemGap) //
              +
              (additionalGap) +
              (additionalTop) //
          ));

      // works well
      Offset topEnd = indicatorCenter.translate(0, -radius);

      // draw upper line
      if (!isFirst) canvas.drawLine(topStart, topEnd, linePaint);
    }
    // endregion upper line

    // endregion downer line
    if (!isLast) {
      double additionalGap = 0;
      if (!nextHasIndicator) additionalGap = halfItemGap;

      final additionalBottom = getAdditionalY(height);

      // works well
      Offset bottomEnd = indicatorCenter.translate(
          0,
          // the altY + radius is the default start point.
          // adding half item gap is also by default.
          // the below two items does not get affected by the indicator position
          (((-altY + radius) + halfItemGap) //
              +
              (additionalGap) +
              (additionalBottom) //
          ));

      // works well
      Offset bottomStart = indicatorCenter.translate(0, -radius);
//      if (!isLast) canvas.drawLine(bottomStart, bottomEnd, testLinePaint);

//
//      Offset bottomStart = indicatorCenter.translate(
//          0, (safeHalfHeight + halfItemGap + indicatorMargin - lineGap));
//      // works well
//      Offset bottomEnd = indicatorCenter.translate(0, radius);

    }
    // endregion downer line
  }

  double getAdditionalY(double height, {int direction = 1}) {
    double add = 0;
    // the additional size should be
    switch (indicatorPosition) {
      case IndicatorPosition.top:
        add = 0;
        break;
      case IndicatorPosition.center:
        add = (height - indicatorSize) / 2;
        break;
      case IndicatorPosition.bottom:
        add = height - indicatorSize;
        break;
    }
    return add * direction;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//    switch (indicatorPosition) {
//      case IndicatorPosition.top:
//        topStart = indicatorCenter.translate(
//            0,
//            -(safeHalfHeight + halfItemGap + indicatorMargin - lineGap) +
//                additionalTopY);
//        break;
//      case IndicatorPosition.center:
//        topStart = indicatorCenter - Offset(0, lineGap);
//        break;
//      case IndicatorPosition.bottom:
//        topStart = indicatorCenter.translate(
//            0,
//            -(safeHalfHeight + halfItemGap + indicatorMargin - lineGap) +
//                additionalTopY);
//        break;
//    }

// painter v1
/*

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
//    if (!isFirst) canvas.drawLine(outboundTop, topOfCenter, linePaint);
    // if not last, draw center-to-bottom bottom line
    if (!isLast) canvas.drawLine(bottomOfCenter, outboundBottom, testLinePaint);
* */
