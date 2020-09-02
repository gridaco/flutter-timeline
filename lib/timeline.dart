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
              alignment: Alignment.center,
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
    final indicatorRadius = indicatorSize / 2;
    final maxIndicatorRadius = maxIndicatorSize / 2;
    final indicatorMargin = indicatorRadius + lineGap;
    final safeItemGap = (indicatorRadius) + itemGap;
    double topStartY = 0.0;

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

    final top = size.topLeft(Offset(maxIndicatorRadius + altX,
        topStartY - safeItemGap + overrideOffsetYForTop));
    final topOfCenter = size.centerLeft(
      Offset(maxIndicatorRadius + altX, -indicatorMargin + altY),
    );

    final bottom = size.bottomLeft(Offset(maxIndicatorRadius + altX,
        0.0 + safeItemGap + overrideOffsetYForBottom));
    final bottomOfCenter = size.centerLeft(
      Offset(maxIndicatorRadius + altX, indicatorMargin + altY),
    );

    // if not first, draw top-to-center  upper line
    if (!isFirst) canvas.drawLine(top, topOfCenter, linePaint);
    // if not last, draw center-to-bottom bottom line
    if (!isLast) canvas.drawLine(bottomOfCenter, bottom, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
