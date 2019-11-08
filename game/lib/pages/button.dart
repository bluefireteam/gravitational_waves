import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';

import '../palette.dart';
import '../util.dart';

class Button {
  String text;
  Rect Function() rectGenerator;
  void Function() action;

  Button(this.text, this.rectGenerator, this.action);

  void render(Canvas canvas) {
    final rect = rectGenerator();
    canvas.drawRect(rect, Palette.menuItems.paint);
    Fonts.menuItems.render(canvas, text, Position.fromOffset(rect.center), anchor: Anchor.center);
  }
}