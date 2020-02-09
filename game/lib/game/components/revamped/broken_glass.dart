import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../../game.dart';

class BrokenGlass extends PositionComponent with HasGameRef<MyGame> {
  BrokenGlass(double x, double y) {
    this.x = x;
    this.y = y;
    this.width = this.height = 24;
  }

  @override
  void render(Canvas c) {
    c.drawRect(toRect(), Paint()..color = Color(0xFFFF00FF)..style = PaintingStyle.stroke);
  }

  @override
  void update(double t) {}

  @override
  bool destroy() => x < gameRef.camera.x;
}