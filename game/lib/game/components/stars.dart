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
  }

  // assumes all stars are the same dimensions
  double get w => Tileset.stars[0].srcSize.x;
  double get h => Tileset.stars[0].srcSize.y;

  @override
  double get y => (gameRef.size.y - h) / 2;

  @override
  void render(Canvas c) {
    super.render(c);

    renderOnce(c, x);
    renderOnce(c, x + gameRef.size.x);
  }

  void renderOnce(Canvas c, double x) {
    repeats
        .map((v) => Tileset.stars[v])
        .toList()
        .asMap()
        .forEach((idx, sprite) => sprite.render(
              c,
              position: Vector2(x + w * idx, y),
            ));
  }

  @override
  void update(double t) {
    super.update(t);

    double speed = gameRef.sleeping ? STARS_IDLE_SPEED : STARS_SPEED;
    x -= speed * t;
    while (x < -gameRef.size.x) x += gameRef.size.x;
  }

  @override
  int get priority => 0;

  @override
  bool get isHud => true;
}
