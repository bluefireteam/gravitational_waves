import 'dart:ui';

import 'palette.dart';

class PauseOverlay {
  static final Paint _filled = Palette.hud.paint..strokeWidth = 4.0;
  static final Paint _hollow = Palette.hud.paint
    ..strokeWidth = 6.0
    ..style = PaintingStyle.stroke;

  static void render(Canvas c, Size size) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _hollow);

    final xOffset = size.width - 8.0;
    final yOffset = 8.0;
    c.drawRect(Rect.fromLTWH(xOffset - 14.0, yOffset, 4.0, 18.0), _filled);
    c.drawRect(Rect.fromLTWH(xOffset - 4.0, yOffset, 4.0, 18.0), _filled);
  }
}
