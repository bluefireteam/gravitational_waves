import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../../game.dart';
import '../../util.dart';

class SpaceBattle extends AnimationComponent with HasGameRef<MyGame>, Resizable {
  static const S = 1.0;
  static const TX_W = 112.0;
  static const TX_H = 80.0;

  bool spawnedShip = false;
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

    if (!spawnedShip && x < (size.width - width) / 2) {
      gameRef.powerups.spawnFiringShip();
      spawnedShip = true;
    }

    if (x < -width) {
      shouldDestroy = true;
    }
  }

  @override
  int priority() => 1;

  @override
  bool isHud() => true;

  @override
  bool destroy() => shouldDestroy;
}
