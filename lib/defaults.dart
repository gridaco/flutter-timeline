import 'package:flutter/material.dart';

class TimelineDots {
  TimelineDots({this.context});

  BuildContext context;

  factory TimelineDots.of(BuildContext context) {
    return TimelineDots(context: context);
  }

  Widget get simple {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget get borderDot {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          image: null,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all()),
    );
  }

  Widget get section {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Colors.black,
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget get sectionHighlighted {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }
}
