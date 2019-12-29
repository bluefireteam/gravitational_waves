import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../game.dart';

class Coin extends AnimationComponent with HasGameRef<MyGame> {

  static const double WIDTH = 12.0, HEIGHT = 12.0;

  bool picked = false;

  Coin(double x, double y) : super(WIDTH, HEIGHT, buildAnimation()) {
    this.x = x - WIDTH / 2;
    this.y = y - HEIGHT / 2;
  }

  static Animation buildAnimation() {
    return Animation.sequenced('crystal.png', 8, textureWidth: 16.0, textureHeight: 16.0);
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
    Rect r = this.toRect().inflate(WIDTH);
    if (r.contains(Offset(x, y))) return true;
    return (x - this.x).abs() < 4 * WIDTH;
  }

  bool get offscreen => x < gameRef.camera.x - gameRef.size.width;

  @override
  bool destroy() => picked || offscreen;

  @override
  int priority() => 4;
}