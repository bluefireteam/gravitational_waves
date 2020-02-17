import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

import '../../util.dart';

class JetpackPickup extends SpriteComponent {
  static final Sprite jetpack = Sprite('jetpack.png');

  static const HOVER_TIME = 1.0;
  static const HOVER_DISTANCE = 4;

  double hoverClock = 0.0;
  double startY;

  JetpackPickup(double x, double y) {
    this.x = x;
    this.y = this.startY = y;
    this.width = this.height = BLOCK_SIZE;
    this.anchor = Anchor.center;
  }

  Sprite get sprite => jetpack;

  @override
  void update(double t) {
    hoverClock = (hoverClock + t / HOVER_TIME) % 1.0;
    double dy = 1 - (2 * hoverClock - 1).abs() * HOVER_DISTANCE;
    y = startY + dy;
  }

  @override
  int priority() => 4;
}