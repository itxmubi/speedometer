import 'package:flutter/widgets.dart';

/// A normalized map point preserving original sample, pause and GPS boundaries.
final class RouteNode {
  const RouteNode(
    this.position,
    this.originalIndex,
    this.segment,
    this.overLimit,
    this.breakBefore,
  );
  final Offset? position;
  final int originalIndex;
  final int segment;
  final bool overLimit;
  final bool breakBefore;
}
