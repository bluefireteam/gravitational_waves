import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/sprite.dart';

import '../../game.dart';
import '../../util.dart';

enum JetpackType { REGULAR, PULSER }

class JetpackPickup extends SpriteComponent with HasGameRef<MyGame> {
  static final Sprite jetpack = Sprite('jetpack.png');
  static final Animation pulser = Animation.sequenced(
    'pulser.png',
    6,
    textureWidth: 16,
    textureHeight: 16,
    loop: false,
  )..currentIndex = 5; // TODO(luan) poor man's set to last frame

  static const HOVER_TIME = 1.0;
  static const HOVER_DISTANCE = 4;

  static const JETPACK_DURATION = 15.0;

  JetpackType type;
  double hoverClock = 0.0;
  double startY;
  bool shouldDestroy = false;

  JetpackPickup(this.type, double x, double y) {
    this.x = x;
    this.y = this.startY = y;
    this.width = this.height = BLOCK_SIZE;
    this.anchor = Anchor.center;
  }

  Sprite get sprite => getSpriteForType(type);

  static Sprite getSpriteForType(JetpackType type) {
    return type == JetpackType.REGULAR ? jetpack : pulser.frames[0].sprite;
  }

  static Animation getAnimationForType(JetpackType type) {
    return type == JetpackType.REGULAR
        ? Animation.spriteList([jetpack])
        : pulser.reversed().reversed(); // TODO(luan) poor man's clone
  }

  @override
  void update(double t) {
    if (shouldDestroy) return;

    super.update(t);

    hoverClock = (hoverClock + t / HOVER_TIME) % 1.0;
    double dy = 1 - (2 * hoverClock - 1).abs() * HOVER_DISTANCE;
    y = startY + dy;

    if (gameRef.player.toRect().overlaps(toRect())) {
      gameRef.player.jetpackType = type;
      gameRef.player.jetpackAnimation = getAnimationForType(type);
      gameRef.player.jetpackTimeout = JETPACK_DURATION;
      shouldDestroy = true;
    }
  }

  @override
  int priority() => 4;

  @override
  bool destroy() => shouldDestroy;
}
