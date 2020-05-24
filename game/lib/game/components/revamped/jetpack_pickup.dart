import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/sprite.dart';

import '../../game.dart';
import '../../util.dart';

class JetpackPickup extends SpriteComponent with HasGameRef<MyGame> {
  static final Sprite jetpack = Sprite('jetpack.png');

  static const HOVER_TIME = 1.0;
  static const HOVER_DISTANCE = 4;

  static const JETPACK_DURATION = 15.0;

  double hoverClock = 0.0;
  double startY;
  bool shouldDestroy = false;

  JetpackPickup(double x, double y) {
    this.x = x;
    this.y = this.startY = y;
    this.width = this.height = BLOCK_SIZE;
    this.anchor = Anchor.center;
  }

  Sprite get sprite => jetpack;

  @override
  void update(double t) {
    if (shouldDestroy) return;

    super.update(t);

    hoverClock = (hoverClock + t / HOVER_TIME) % 1.0;
    double dy = 1 - (2 * hoverClock - 1).abs() * HOVER_DISTANCE;
    y = startY + dy;

    if (gameRef.player.toRect().overlaps(toRect())) {
      gameRef.player.jetpackTimeout = JETPACK_DURATION;
      shouldDestroy = true;
    }
  }

  @override
  int priority() => 4;

  @override
  bool destroy() => shouldDestroy;
}