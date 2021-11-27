import 'dart:ui';

import 'package:flame/components.dart';

import '../assets/tileset.dart';
import '../collections.dart';
import '../game.dart';
import '../util.dart';

class Stars extends PositionComponent with HasGameRef<MyGame> {
  late List<int> repeats;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    int amount = (gameRef.size.x / w).ceil();
    repeats = List.generate(amount, (_) => Tileset.stars.randomIdx(R));

    x = 0;
    y = (gameRef.size.y - h) / 2;
  }

  // assumes all stars are the same dimensions
  double get w => Tileset.stars[0].srcSize.x;
  double get h => Tileset.stars[0].srcSize.y;

  @override
  void render(Canvas c) {
    super.render(c);

    renderOnce(c, 0);
    renderOnce(c, gameRef.size.x);
  }

  void renderOnce(Canvas c, double x) {
    repeats.forEachIndexed((idx, value) {
      final sprite = Tileset.stars[value];
      sprite.render(c, position: Vector2(x + w * idx, 0));
    });
  }

  @override
  void update(double t) {
    super.update(t);

    final speed = gameRef.sleeping ? STARS_IDLE_SPEED : STARS_SPEED;
    x -= speed * t;
    while (x < -gameRef.size.x) {
      x += gameRef.size.x;
    }
  }

  @override
  int get priority => 0;

  @override
  bool get isHud => true;
}
