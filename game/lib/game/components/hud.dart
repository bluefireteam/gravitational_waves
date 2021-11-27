import 'dart:ui';

import 'package:flame/components.dart';

import '../game.dart';
import '../util.dart';
import 'coin.dart';

class Hud extends Component with HasGameRef<MyGame> {
  static const double MARGIN = 8.0;

  late Sprite coin;
  late NineTileBox bg;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    coin = await Coin.loadSprite();
    bg = NineTileBox(await Sprite.load('container-tileset.png'), tileSize: 16);
  }

  @override
  void render(Canvas c) {
    if (gameRef.paused) {
      return;
    }

    super.render(c);
    final p1 = "${gameRef.score}m";
    final p2 = "x${gameRef.coins}";

    double coinSpace = MARGIN + Coin.SIZE;

    final tp1 = Fonts.hud.toTextPainter(p1);
    final tp2 = Fonts.hud.toTextPainter(p2);

    final width = tp1.width + tp2.width + coinSpace + 2 * MARGIN;
    final height = tp1.height + 2 * MARGIN;

    final x = (gameRef.size.x - width) / 2.0;
    final x1 = x + MARGIN;
    final x2 = x1 + tp1.width + MARGIN;
    final x3 = x2 + Coin.SIZE;

    bg.draw(c, Vector2(x, 0), Vector2(width, height));

    Fonts.hud.render(c, p1, Vector2(x1, MARGIN));

    Vector2 p = Vector2(x2, (height - Coin.SIZE) / 2);
    Vector2 size = Vector2(Coin.SIZE, Coin.SIZE);
    coin.render(c, position: p, size: size);

    Fonts.hud.render(c, p2, Vector2(x3, MARGIN));
  }

  @override
  bool get isHud => true;

  @override
  int get priority => 6;
}
