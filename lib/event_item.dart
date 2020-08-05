import 'package:flutter/material.dart';

class EventDisplay {
  EventDisplay({@required this.child, this.indicator});

  final Widget child;
  final Widget indicator;

  bool get hasIndicator {
    return indicator != null;
  }
}
