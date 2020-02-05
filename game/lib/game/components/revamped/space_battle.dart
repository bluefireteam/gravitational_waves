import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../../game.dart';
import '../../util.dart';

class SpaceBattle extends AnimationComponent with HasGameRef<MyGame> {
  static const S = 2.0;
  static const TX_W = 112.0;
  static const TX_H = 80.0;

  bool shouldDestroy = false;

  SpaceBattle(Size size)
      : super.sequenced(S * TX_W, S * TX_H, 'spacebattle.png', 12,
            textureWidth: TX_W, textureHeight: TX_H
            /*, stepTime: 0.15 // TODO waiting for new flame release */) {
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
      gameRef.powerups.spawnFiringShip();
    }
  }

  @override
  int priority() => 1;

  @override
  bool isHud() => true;

  @override
  bool destroy() => shouldDestroy;
}
