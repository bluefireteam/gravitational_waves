import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';

import '../column.dart';
import '../util.dart';

class Tutorial extends Component with Resizable {
  static const POSITIONS = [100, 200];

  static Iterable<Column> generateTerrain() {
    // TODO generate tutorial
    return List.generate(128, (_) => Column(0, 0));
  }

  bool destroyed = false;
  Animation animation = Animation.sequenced('hand.png', 2, textureWidth: 32.0, textureHeight: 48.0, stepTime: 0.6);

  @override
  void render(Canvas c) {
    Position p = Position(size.width / 2, size.height / 2);
    Fonts.tutorial.render(c, 'Tap to change gravity', p, anchor: Anchor.center);
    // TODO: implement render

    animation.getSprite().renderPosition(c, Position(32.0, 32.0));
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
