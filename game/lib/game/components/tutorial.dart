import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';

import '../util.dart';

class Tutorial extends Component with Resizable {
  static const POSITIONS = [100, 200];

  bool destroyed = false;

  @override
  void render(Canvas c) {
    Position p = Position(size.width / 2, size.height / 2);
    Fonts.tutorial.render(c, 'Tap to change gravity', p, anchor: Anchor.center);
    // TODO: implement render
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  void remove() {
    destroyed = true;
  }

  @override
  int priority() => 7;

  @override
  bool destroy() => destroyed;
}