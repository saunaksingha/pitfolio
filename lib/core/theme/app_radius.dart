import 'package:flutter/material.dart';

/// Standard corner radii used throughout Pitfolio.
abstract final class AppRadius {
  static const double small = 6;
  static const double medium = 10;
  static const double large = 12;
  static const double extraLarge = 16;
  static const double card = 18;
  static const double pill = 999;

  static const BorderRadius smallRadius = BorderRadius.all(
    Radius.circular(small),
  );

  static const BorderRadius mediumRadius = BorderRadius.all(
    Radius.circular(medium),
  );

  static const BorderRadius largeRadius = BorderRadius.all(
    Radius.circular(large),
  );

  static const BorderRadius extraLargeRadius = BorderRadius.all(
    Radius.circular(extraLarge),
  );

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
}
