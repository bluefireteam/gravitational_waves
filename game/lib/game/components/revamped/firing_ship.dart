import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../../game.dart';
import '../../util.dart';

class FiringShip extends AnimationComponent with HasGameRef<MyGame> {
  static const S = 2.0;
  static const TX_W = 80.0;
  static const TX_H = 48.0;

  bool shouldDestroy = false;

  FiringShip(Size size)
      : super.sequenced(S * TX_W, S * TX_H, 'firing-ship.png', 8,
            textureWidth: TX_W, textureHeight: TX_H) {
    this.x = size.width + width;
    this.y = R.nextDouble() * (size.height - height);
  }

  @override
  void update(double t) {
    if (shouldDestroy) {
      return;
    }

    super.update(t);
    x -= SHIPS_SPEED * t;

    if (x < -width) {
      shouldDestroy = true;
      gameRef.powerups.spawnGlassHoles();
    }
  }

  @override
  int priority() => 1;

  @override
  bool isHud() => true;

  @override
  bool destroy() => shouldDestroy;
}
