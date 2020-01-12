import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';

import '../column.dart';
import '../util.dart';

class Tutorial extends Component with Resizable {
  static final positions = [64 - 6, 64 + 12]
    .map((e) => (-CHUNCK_SIZE / 2.0 + e) * BLOCK_SIZE)
    .toList();

  static Iterable<Column> generateTerrain() {
    return List.generate(64, (_) => Column(0, 0))
           + List.generate(8, (_) => Column(1, 0))
           + List.generate(10, (_) => Column(0, 0))
           + List.generate(8, (_) => Column(0, 1))
           + List.generate(8, (_) => Column(0, 0));
  }

  bool destroyed = false;
  Animation animation = Animation.sequenced('hand.png', 2, textureWidth: 32.0, textureHeight: 48.0, stepTime: 0.6);

  @override
  void render(Canvas c) {
    Position p1 = Position(size.width / 2, size.height - 48.0 - 48.0);
    Fonts.tutorial.render(c, 'Tap to change', p1, anchor: Anchor.bottomCenter);

    Position p2 = Position(size.width / 2, size.height - 32.0 - 48.0);
    Fonts.tutorial.render(c, 'gravity', p2, anchor: Anchor.bottomCenter);

    Position p3 = Position(size.width / 2, size.height - 16.0 - 48.0);
    animation.getSprite().renderPosition(c, p3);
  }

  @override
  void update(double t) {
    animation.update(t);
  }

  void remove() {
    destroyed = true;
  }

  @override
  int priority() => 7;

  @override
  bool isHud() => true;

  @override
  bool destroy() => destroyed;
}
