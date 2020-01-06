import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/sprite.dart';

import '../assets/nine_box.dart';
import '../game.dart';

class Hud extends PositionComponent with HasGameRef<MyGame> {

  static final NineBox bg = NineBox(Sprite('container-tileset.png'), 16);

  Hud() {
    this.width = 400;
    this.height = 40;
  }

  @override
  void render(Canvas c) {
    bg.draw(c, (gameRef.size.width - width) / 2, 0, width, height);
    // TODO draw text
  }

  @override
  void update(double t) {}

  @override
  bool isHud() => true;

  @override
  int priority() => 6;
}