import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';

import 'palette.dart';
import 'util.dart';

class PauseOverlay {
  static final Paint _filled = Palette.hud.paint..strokeWidth = 4.0;
  static final Paint _hollow = Palette.hud.paint
    ..strokeWidth = 6.0
    ..style = PaintingStyle.stroke;

  static void render(Canvas c, Size size, bool showMessage) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _hollow);

    final xOffset = size.width - 8.0;
    final yOffset = 8.0;
    c.drawRect(Rect.fromLTWH(xOffset - 14.0, yOffset, 4.0, 18.0), _filled);
    c.drawRect(Rect.fromLTWH(xOffset - 4.0, yOffset, 4.0, 18.0), _filled);

    if (showMessage) {
      Position p = Position(size.width / 2, size.height  / 2);
      Fonts.tutorial.render(c, 'Tap to resume', p, anchor: Anchor.center);
    }
  }
}
