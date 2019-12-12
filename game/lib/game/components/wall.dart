import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import '../game.dart';

import '../palette.dart';
import '../assets/tileset.dart';

class Wall extends PositionComponent with Resizable, HasGameRef<MyGame> {
  static final Paint _wall = Palette.wall.paint;

  Sprite get sprite => Tileset.wall;
  double get w => sprite.size.x;
  double get h => sprite.size.y;

  @override
  void render(Canvas c) {
    renderColorBg(c);
    renderWall(c);
  }

  void renderColorBg(Canvas c) {
    c.drawRect(Rect.fromLTWH(-size.width / 2, 0.0, 2 * size.width, (size.height - h) / 2), _wall);
    c.drawRect(Rect.fromLTWH(-size.width / 2, (size.height + h) / 2, 2 * size.width, (size.height - h) / 2), _wall);
  }

  void renderWall(Canvas c) {
    double dx = x;
    while (dx < size.width + w) {
      sprite.renderCentered(c, Position(dx, size.height / 2), size: Position(w, h));
      dx += w;
    }
  }

  @override
  void update(double t) {
    x = -w - (gameRef.player.x % w);
  }

  @override
  bool isHud() => true;

  @override
  int priority() => 2;
}
