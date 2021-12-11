import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../game.dart';
import '../../util.dart';
import '../coin.dart';
import 'poof.dart';

class CrystalContainerPickup extends SpriteComponent with HasGameRef<MyGame> {
  static const SPAWN_TIMER = 0.05;
  static const TOTAL_TIMER = 4;

  late final SpriteAnimation animation;

  // 0 idle, 1 spawning, 2 destroy
  int _state = 0;

  int iteration = 0;
  double clock = 0.0;

  CrystalContainerPickup(double x, double y) {
    this.x = x;
    this.y = y;
    this.width = BLOCK_SIZE / 2;
    this.height = BLOCK_SIZE;
    this.anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await SpriteAnimation.load(
      'crystal_container.png',
      SpriteAnimationData.sequenced(
        amount: 16,
        textureSize: Vector2(16, 32),
        stepTime: 0.150,
      ),
    );
  }

  Sprite get sprite => animation.getSprite();

  @override
  void render(Canvas c) {
    if (_state == 0) {
      super.render(c);
    }
  }

  @override
  void update(double t) {
    if (_state >= 2) {
      removeFromParent();
      return;
    }

    if (_state == 0) {
      super.update(t);
      animation.update(t);

      if (gameRef.player.toRect().overlaps(toRect())) {
        _state++;
      }
    } else {
      clock += t;
      if (clock >= SPAWN_TIMER) {
        clock -= SPAWN_TIMER;
        iteration++;
        if (iteration * SPAWN_TIMER >= TOTAL_TIMER) {
          _state++;
        } else {
          spawnRandomCrystal();
        }
      }
    }
  }

  void spawnRandomCrystal() {
    double startX = gameRef.player.x + BLOCK_SIZE;
    double endX = startX + gameRef.size.x / 2;
    double randomX = startX + R.nextDouble() * (endX - startX);
    Rect column =
        gameRef.findBackgroundForX(randomX).findRectContaining(randomX);
    bool top = R.nextBool();
    double x = column.left + column.size.width / 2;
    double y =
        top ? column.top + BLOCK_SIZE / 2 : column.bottom - BLOCK_SIZE / 2;
    if (!gameRef.children.any((e) => e is Coin && e.overlaps(x, y))) {
      gameRef.add(Poof(x, y));
      gameRef.add(Coin(x, y));
    }
  }

  @override
  int get priority => 4;
}
