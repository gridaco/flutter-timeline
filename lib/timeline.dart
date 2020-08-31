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
    this.indicatorSize = 12.0,
    // item gap will be ignored when custom separatorBuilder is provided
    this.separatorBuilder,
    this.altOffset = const Offset(0, 0),
  }) : itemCount = events.length;

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
        final isFirst = index == 0;
        final isLast = index == itemCount - 1;
        final timelineTile = <Widget>[
          if (event.hasIndicator)
            _buildIndicatorSection(
                isFirst: isFirst,
                isLast: isLast,
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
      TimelineEventDisplay event,
      TimelineThemeData theme}) {
    var overrideIndicatorSize =
        event.indicatorSize != null ? event.indicatorSize : indicatorSize;
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
  _LineIndicatorPainter({
    @required this.hideDefaultIndicator,
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
    @required this.itemGap,
  }) : linePaint = Paint()
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
  final double itemGap;

  @override
  void paint(Canvas canvas, Size size) {
    final indicatorRadius = indicatorSize / 2;
    final maxIndicatorRadius = maxIndicatorSize / 2;
    final indicatorMargin = indicatorRadius + lineGap;
    final safeItemGap = (indicatorSize / 2) + lineGap;
    final altY = altOffset.dy;

    // todo
    // calculate starting point
    // calculate alt point
    // use alt point as default point

    final top =
        size.topLeft(Offset(maxIndicatorRadius, 0.0 - safeItemGap + altY));
    final topOfCenter = size.centerLeft(
      Offset(maxIndicatorRadius, -indicatorMargin + altY),
    );

    final bottom =
        size.bottomLeft(Offset(maxIndicatorRadius, 0.0 + safeItemGap + altY));
    final bottomOfCenter = size.centerLeft(
      Offset(maxIndicatorRadius, indicatorMargin + altY),
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
