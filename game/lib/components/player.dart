import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import 'background.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, Resizable {

  static const double PLAYER_SPEED = 25.0;
  static final Paint _paint = Paint()..color = const Color(0xFFFFFF00);

  double speedY;

  Player(Size size) {
    this.x = 0.0;
    this.y = size.height / 2;
    this.speedY = 0.0;
  }

  double get playerSize => size.width * 2 / Background.CHUNCK_SIZE;

  @override
  double get width => playerSize;

  @override
  double get height => playerSize;

  @override
  void render(Canvas c) {
    c.drawRect(toRect(), _paint);

    c.drawRect(getCurrentRect(), Paint()..color = Color(0xFFFF2266)..style = PaintingStyle.stroke);
  }

  @override
  void update(double dt) {
    x += dt * PLAYER_SPEED;

    double accY = gameRef.gravity;
    y += accY * dt * dt / 2 + speedY * dt;
    speedY += accY * dt;

    final rect = getCurrentRect();
    if (y < rect.top) {
      y = rect.top;
      speedY = 0;
    } else if (y > rect.bottom - height) {
      y = rect.bottom - height;
      speedY = 0;
    }
  }

  Rect getCurrentRect() {
    return gameRef.components
      .where((c) => c is Background)
      .map((c) => c as Background)
      .firstWhere((c) => c.contains(this))
      .findRectContaining(this.x);
  }

  @override
  int priority() => 2;
}