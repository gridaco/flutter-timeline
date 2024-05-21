import 'package:flutter/material.dart';

class TimelineDots {
  TimelineDots({required this.context});

  BuildContext context;

  factory TimelineDots.of(BuildContext context) {
    return TimelineDots(context: context);
  }

  Widget get simple {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget get borderDot {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          image: null,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all()),
    );
  }

  Widget get icon {
    return Icon(Icons.event);
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

  Widget get circleIcon {
    return Container(
      width: 24,
      height: 24,
      child: Icon(
        Icons.event,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(
            Radius.circular(64),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.lightBlueAccent,
                blurRadius: 16,
                offset: Offset(0, 4))
          ]),
    );
  }

  Widget get sectionHighlighted {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }
}
