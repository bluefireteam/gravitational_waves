import 'dart:ui';

import 'package:flame/position.dart';

import '../game.dart';

abstract class Page {
  MyGame gameRef;

  Page(this.gameRef);

  void render(Canvas canvas);
  void tap(Position p);
}