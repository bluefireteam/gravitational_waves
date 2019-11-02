import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import 'background.dart';

class Player extends PositionComponent with HasGameRef<MyGame>, Resizable {

  static const double PLAYER_SPEED = 10.0;
  static final Paint _paint = Paint()..color = const Color(0xFFFFFF00);

  double get playerSize => size.width * 2 / Background.CHUNCK_SIZE;

  @override
  double get width => playerSize;

  @override
  double get height => playerSize;

  @override
  void render(Canvas c) {
    c.drawRect(toRect(), _paint);
  }

  @override
  void update(double t) {
    x += t * PLAYER_SPEED;
    // TODO impl gravity!
  }
}