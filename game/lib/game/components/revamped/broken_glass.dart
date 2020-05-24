import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/position.dart';

import '../../assets/poofs.dart';
import '../../game.dart';
import '../../util.dart';

class BrokenGlass extends PositionComponent with HasGameRef<MyGame> {
  Animation animation = Poofs.airEscaping();

  BrokenGlass(double x, double y) {
    this.x = x;
    this.y = y;
    this.width = this.height = BLOCK_SIZE;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);
    animation.getSprite().render(c);
    if (RENDER_GLASS) {
      c.drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = Color(0xFFFF00FF)..style = PaintingStyle.stroke);
    }
  }

  @override
  void update(double t) {
    super.update(t);
    animation.update(t);

    final player = gameRef.player.toRect();
    final rect = toRect();
    if (player.overlaps(rect)) {
      gameRef.player.suck(Position.fromOffset(rect.center));
    }
  }

  @override
  bool destroy() => x < gameRef.camera.x;
}