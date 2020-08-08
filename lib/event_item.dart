import 'package:flutter/material.dart';

class TimelineEventDisplay {
  TimelineEventDisplay(
      {@required @required this.child,
      this.indicator,
      this.forceLineDrawing = false});

  final Widget child;
  final Widget indicator;

  /// enables indicator line drawing even no indicator is passed.
  final bool forceLineDrawing;

  bool get hasIndicator {
    return indicator != null;
  }
}

class TimelineEventCard extends StatelessWidget {
  final Widget title;
  final Widget content;

  TimelineEventCard({@required this.title, @required this.content});

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
        padding: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 20),
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
        style: Theme.of(context).textTheme.subtitle1, child: title);
  }

  Widget _description(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.overline, child: content);
  }
}

class TimelineSectionDivider extends StatelessWidget {
  final Widget content;

  factory TimelineSectionDivider.byDate(DateTime date) {
    return TimelineSectionDivider(
      content: Text("$date"),
    );
  }

  const TimelineSectionDivider({Key key, @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return AnimatedDefaultTextStyle(
        child: content,
        style: Theme.of(context).textTheme.headline5,
        duration: kThemeChangeDuration);
  }
}
