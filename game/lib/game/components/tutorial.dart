import 'dart:ui';

import 'package:flame/components.dart';

import '../column.dart';
import '../game.dart';
import '../util.dart';

class Tutorial extends Component with HasGameRef<MyGame> {
  static final positions = [64 - 6, 64 + 12]
      .map((e) => (-CHUNCK_SIZE / 2.0 + e) * BLOCK_SIZE)
      .toList();

  static Iterable<Column> generateTerrain() {
    return List.generate(64, (_) => Column(0, 0)) +
        List.generate(8, (_) => Column(1, 0)) +
        List.generate(10, (_) => Column(0, 0)) +
        List.generate(8, (_) => Column(0, 1)) +
        List.generate(8, (_) => Column(0, 0));
  }

  late SpriteAnimation animation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await SpriteAnimation.load(
      'hand.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2(32.0, 48.0),
        stepTime: 0.6,
      ),
    );
  }

  @override
  void render(Canvas c) {
    super.render(c);

    final gameSize = gameRef.size;

    Vector2 p1 = Vector2(gameSize.x / 2, gameSize.y - 48.0 - 48.0);
    Fonts.tutorial.render(c, 'Tap to change', p1, anchor: Anchor.bottomCenter);

    Vector2 p2 = Vector2(gameSize.x / 2, gameSize.y - 32.0 - 48.0);
    Fonts.tutorial.render(c, 'gravity', p2, anchor: Anchor.bottomCenter);

    Vector2 p3 = Vector2(gameSize.x / 2, gameSize.y - 16.0 - 48.0);
    animation.getSprite().render(c, position: p3);
  }

  @override
  void update(double t) {
    super.update(t);
    animation.update(t);
  }

  @override
  int get priority => 7;

  @override
  bool get isHud => true;
}
