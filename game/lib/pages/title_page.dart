import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';

import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'page.dart';

class TitlePage extends Page {

  static List<String> items = ['New Game', 'Quit'];

  TitlePage(MyGame gameRef) : super(gameRef);

  Size get size => gameRef.size;

  @override
  void render(Canvas canvas) {
    final colSize = size.width / (2 * items.length + 1);
    final rowSize = size.height / 4;

    Fonts.menuTitle.render(canvas, 'Gravitional Waves', Position(size.width / 2, rowSize), anchor: Anchor.center);

    double currentX = colSize;
    for (final item in items) {
      final rect = Rect.fromLTWH(currentX, 5/2 * rowSize, colSize, rowSize);
      canvas.drawRect(rect, Palette.menuItems.paint);
      Fonts.menuItems.render(canvas, item, Position.fromOffset(rect.center), anchor: Anchor.center);
      currentX += 2 * colSize;
    }
  }

  void tap(Position p) {
    // TODO handle menu items
    gameRef.start();
  }
}