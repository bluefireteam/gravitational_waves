import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:gravitational_waves/util.dart';

import '../collections.dart';
import '../assets/tileset.dart';

class Planet extends SpriteComponent with Resizable {

  Planet(Size size) {
    this.sprite = sample(Tileset.planets);
    this.width = sprite.size.x;
    this.height = sprite.size.y;

    this.x = size.width + width;
    this.y = R.nextDouble() * (size.height - height);
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= PLANET_SPEED * t;
  }

  @override
  int priority() => 1;

  @override
  bool isHud() => true;

  @override
  bool destroy() => x < -width;
}