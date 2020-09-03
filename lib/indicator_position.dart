import 'package:flutter/widgets.dart';

enum IndicatorPosition { top, center, bottom }

extension Mapper on IndicatorPosition {
  Alignment get asAlignment {
    switch (this) {
      case IndicatorPosition.top:
        return Alignment.topCenter;
        break;
      case IndicatorPosition.center:
        return Alignment.center;
        break;
      case IndicatorPosition.bottom:
        return Alignment.bottomCenter;
        break;
    }
    return Alignment.center;
  }
}
