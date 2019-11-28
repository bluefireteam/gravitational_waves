import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';
import 'package:gravitational_waves/util.dart';

import '../collections.dart';
import 'tileset.dart';

class Stars extends PositionComponent with Resizable {

  List<int> repeats;

  Stars(Size size) {
    int amount = (size.width / w).ceil();
    repeats = List.generate(amount, (_) => randomIdx(Tileset.stars));

    x = 0;
  }

  // assumes all stars are the same dimensions
  double get w => Tileset.stars[0].size.x;
  double get h => Tileset.stars[0].size.y;

  @override
  double get y => (size.height - h) / 2;

  @override
  void render(Canvas c) {
    renderOnce(c, x);
    renderOnce(c, x + size.width);
  }

  void renderOnce(Canvas c, double x) {
    repeats
      .map((v) => Tileset.stars[v])
      .toList()
      .asMap()
      .forEach((idx, sprite) => sprite.renderPosition(c, Position(x + w * idx, y)));
  }

  @override
  void update(double t) {
    x -= STARS_SPEED * t;
    while (x < -size.width) x += size.width;
  }

  @override
  int priority() => 0;

  @override
  bool isHud() => true;
}