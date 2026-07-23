/// Animation curve tokens for Basir
library;

import 'package:flutter/material.dart';

/// Animation curve constants
abstract final class AnimationCurves {
  static const Curve decelerate = Curves.decelerate;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
}
