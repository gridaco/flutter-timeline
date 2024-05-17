import 'package:flutter/material.dart';

import 'indicator_position.dart';

class TimelineEventDisplay {
  TimelineEventDisplay({
    required this.child,
    this.indicator,
    this.indicatorSize,
    this.forceLineDrawing = false,
    this.anchor,
    this.indicatorOffset = const Offset(0, 0),
  });

  final Widget child;

  /// if not provided, use the default indicator size
  final double? indicatorSize;
  final Widget? indicator;

  /// enables indicator line drawing even no indicator is passed.
  final bool forceLineDrawing;

  /// [anchor] overrides the default IndicatorPosition
  final IndicatorPosition? anchor;
  final Offset indicatorOffset;

  bool get hasIndicator {
    return indicator != null;
  }

  @override
  String toString() {
    return "Instance of TimelineEventDisplay:: indicator size = $indicatorSize";
  }
}

class TimelineEventCard extends StatelessWidget {
  final Widget title;
  final Widget content;
  final EdgeInsetsGeometry padding;

  TimelineEventCard({
    required this.title,
    required this.content,
    this.padding =
        const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
        ),
        child: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context),
            SizedBox(
              height: 8,
            ),
            _description(context),
          ],
        ));
  }

  Widget _title(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleMedium ?? TextStyle(),
      child: title,
    );
  }

  Widget _description(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.labelSmall ?? TextStyle(),
      child: content,
    );
  }
}

class TimelineSectionDivider extends StatelessWidget {
  final Widget content;

  factory TimelineSectionDivider.byDate(DateTime date) {
    return TimelineSectionDivider(
      content: Text("$date"),
    );
  }

  const TimelineSectionDivider({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return AnimatedDefaultTextStyle(
        child: content,
        style: Theme.of(context).textTheme.headlineSmall ?? TextStyle(),
        duration: kThemeChangeDuration);
  }
}
