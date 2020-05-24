import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/position.dart';

import '../../assets/poofs.dart';
import '../../game.dart';
import '../../util.dart';

class BrokenGlass extends PositionComponent with HasGameRef<MyGame> {
  static final Position deltaCenter = Position(BLOCK_SIZE, BLOCK_SIZE).div(2);

  Animation animation = Poofs.airEscaping();
  Animation initialAnimation = Poofs.glassBreaking();

  BrokenGlass(double x, double y) {
    this.x = x;
    this.y = y;
    this.width = this.height = BLOCK_SIZE;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);
    if (!initialAnimation.done()) {
      initialAnimation.getSprite().renderCentered(c, deltaCenter);
    }
    animation.getSprite().render(c);
    if (RENDER_GLASS) {
      c.drawRect(Rect.fromLTWH(0, 0, width, height), Paint()..color = Color(0xFFFF00FF)..style = PaintingStyle.stroke);
    }
  }

  @override
  void update(double t) {
    super.update(t);
    initialAnimation.update(t);
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