import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';

class Button {
  String text;
  Rect Function() rectGenerator;
  void Function() action;

  Button(this.text, this.rectGenerator, this.action);

  void render(Canvas canvas, TextConfig font, Paint paint) {
    final rect = rectGenerator();
    canvas.drawRect(rect, paint);
    font.render(canvas, text, Position.fromOffset(rect.center), anchor: Anchor.center);
  }
}