import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../game.dart';

class Coin extends PositionComponent with HasGameRef<MyGame> {

  static const double WIDTH = 12.0, HEIGHT = 12.0;

  Coin(double x, double y) {
    this.x = x - WIDTH / 2;
    this.y = y - HEIGHT / 2;
    this.width = WIDTH;
    this.height = HEIGHT;
  }

  @override
  void render(Canvas c) {
    c.drawRect(toRect(), Paint()..color = const Color(0xFFFF00FF));
  }

  @override
  void update(double t) {
    if (gameRef.player.toRect().overlaps(toRect())) {
      // TODO pickup
      print('pickup coin');
    }
  }

  bool overlaps(double x, double y) {
    Rect r = this.toRect().inflate(2 * WIDTH);
    return r.contains(Offset(x, y));
  }

  @override
  bool destroy() => x < gameRef.camera.x - gameRef.size.width;

  @override
  int priority() => 5;
}