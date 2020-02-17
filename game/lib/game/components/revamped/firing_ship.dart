import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../../game.dart';
import '../../spawner.dart';
import '../../util.dart';

class FiringShip extends AnimationComponent with HasGameRef<MyGame> {
  static Spawner brokenGlassSpawner = Spawner(0.000005);

  static const S = 2.0;
  static const TX_W = 80.0;
  static const TX_H = 48.0;
  static const APPROXIMATION_TIME = 2.0;
  static const FIRING_TIME = 4.0;

  bool shouldDestroy = false;

  double scale;
  double clock = 0.0;

  FiringShip(Size size)
      : super.sequenced(S * TX_W, S * TX_H, 'firing-ship.png', 8,
            textureWidth: TX_W, textureHeight: TX_H) {
    this.x = (size.width) / 2;
    this.y = (size.height) / 2;
    this.scale = 0;
    this.anchor = Anchor.center;
    this.animation.loop = true;
  }

  @override double get width => TX_W * scale;
  @override double get height => TX_H * scale;

  @override
  void update(double t) {
    if (shouldDestroy) {
      return;
    }

    this.scale += (t / APPROXIMATION_TIME);
    this.scale = this.scale.clamp(0.0, 1.0);

    if (this.scale >= 0.8 && clock < FIRING_TIME) {
      // tick animation
      super.update(t);
      clock += t;
      brokenGlassSpawner.maybeSpawn(t, () {
        int numberToGenerate = R.nextInt(1) + 1;
        gameRef.wall.spawnBrokenGlass(numberToGenerate);
      });
    }

    if (clock >= FIRING_TIME) {
      y -= SHIPS_SPEED * t;
    }

    if (y < -height) {
      shouldDestroy = true;
      gameRef.powerups.hasSpaceBattle = false;
    }
  }

  @override
  int priority() => 1;

  @override
  bool isHud() => true;

  @override
  bool destroy() => shouldDestroy;
}
