import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import '../assets/nine_box.dart';
import '../game.dart';
import '../util.dart';
import 'coin.dart';

class Hud extends Component {

  static final NineBox bg = NineBox(Sprite('container-tileset.png'), tileSize: 16);
  static const double MARGIN = 8.0;

  MyGame gameRef;

  Hud(this.gameRef);

  @override
  void render(Canvas c) {
    final p1 = "${gameRef.score}m";
    final p2 = "x${gameRef.coins}";

    double coinSpace = MARGIN + Coin.SIZE;

    final tp1 = Fonts.hud.toTextPainter(p1);
    final tp2 = Fonts.hud.toTextPainter(p2);

    final width = tp1.width + tp2.width + coinSpace + 2*MARGIN;
    final height = tp1.height + 2*MARGIN;

    final x = (gameRef.size.width - width) / 2.0;
    final x1 = x + MARGIN;
    final x2 = x1 + tp1.width + MARGIN;
    final x3 = x2 + Coin.SIZE;

    bg.draw(c, x, 0.0, width, height);

    Fonts.hud.render(c, p1, Position(x1, MARGIN));

    Position p = Position(x2, (height - Coin.SIZE) / 2);
    Position size = Position(Coin.SIZE, Coin.SIZE);
    Coin.still.renderPosition(c, p, size: size);

    Fonts.hud.render(c, p2, Position(x3, MARGIN));
  }

  @override
  void update(double t) {}

  @override
  bool isHud() => true;

  @override
  int priority() => 6;
}