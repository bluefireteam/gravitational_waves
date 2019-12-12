import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/text_config.dart';

import '../palette.dart';
import '../util.dart';
import 'button.dart';
import 'page.dart';

mixin WithButtons on Page {
  List<Button> get buttons;

  TextConfig get font => Fonts.menuItems;
  Paint get paint => Palette.menuItems.paint;

  @override
  void tap(Position p) {
    Offset offset = p.toOffset();
    buttons.firstWhere((b) => b.rectGenerator().contains(offset), orElse: () => null)?.action();
  }

  void renderButtons(Canvas c) {
    buttons.forEach((b) => b.render(c, font, paint));
  }
}