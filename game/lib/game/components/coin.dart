import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/sprite.dart';

import '../game.dart';

class Coin extends AnimationComponent with HasGameRef<MyGame> {
  static const double SRC_SIZE = 16.0;
  static const double SIZE = 12.0;

  static final Sprite still =
      Sprite('crystal.png', width: SRC_SIZE, height: SRC_SIZE, x: 3 * SRC_SIZE);

  bool picked = false;

  Coin(double x, double y) : super(SIZE, SIZE, buildAnimation()) {
    this.x = x - SIZE / 2;
    this.y = y - SIZE / 2;
  }

  static Animation buildAnimation() {
    return Animation.sequenced('crystal.png', 8,
        textureWidth: SRC_SIZE, textureHeight: SRC_SIZE);
  }

  @override
  void update(double t) {
    if (picked) {
      return;
    }

    super.update(t);
    if (gameRef.player.toRect().overlaps(toRect())) {
      gameRef.player.shine();
      gameRef.collectCoin();
      picked = true;
    }
  }

  bool overlaps(double x, double y) {
    Rect r = this.toRect().inflate(SIZE);
    if (r.contains(Offset(x, y))) return true;
    return (x - this.x).abs() < 4 * SIZE;
  }

  bool get offscreen => x < gameRef.camera.x - gameRef.size.width;

  @override
  bool destroy() => picked || offscreen;

  @override
  int priority() => 4;
}
