import 'dart:ui';

import 'package:flame/components.dart';

import '../game.dart';

class Coin extends SpriteAnimationComponent with HasGameRef<MyGame> {
  static const double SRC_SIZE = 16.0;
  static const double SIZE = 12.0;

  static Future<Sprite> loadSprite() async => Sprite.load(
        'crystal.png',
        srcPosition: Vector2(3 * SRC_SIZE, 0),
        srcSize: Vector2.all(SRC_SIZE),
      );

  Coin(double x, double y) : super(size: Vector2.all(SIZE)) {
    this.x = x - SIZE / 2;
    this.y = y - SIZE / 2;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await SpriteAnimation.load(
      'crystal.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(SRC_SIZE),
        stepTime: 0.150,
      ),
    );
  }

  @override
  void update(double t) {
    if (offscreen) {
      removeFromParent();
    }

    super.update(t);
    if (gameRef.player.toRect().overlaps(toRect())) {
      gameRef.player.shine();
      gameRef.collectCoin();
      removeFromParent();
    }
  }

  bool overlaps(double x, double y) {
    final r = toRect().inflate(SIZE);
    if (r.contains(Offset(x, y))) {
      return true;
    }
    return (x - this.x).abs() < 4 * SIZE;
  }

  bool get offscreen => x < gameRef.camera.position.x - gameRef.size.x;

  @override
  int get priority => 4;
}
