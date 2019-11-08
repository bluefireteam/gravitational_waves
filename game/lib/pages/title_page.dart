import 'dart:ui';
import 'dart:io';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';

import '../game.dart';
import '../util.dart';
import 'button.dart';
import 'page.dart';

class TitlePage extends Page {

  List<Button> buttons;

  TitlePage(MyGame gameRef) : super(gameRef) {
    buttons = [
      Button('New Game', () => getRectAt(0), doNewGame),
      Button('Quit', () => getRectAt(1), doQuit),
    ];
  }

  Size get size => gameRef.size;

  double get colSize => size.width / (2 * buttons.length + 1);
  double get rowSize => size.height / 4;

  Rect getRectAt(int idx) {
    final currentX = (2 * idx + 1) * colSize;
    return Rect.fromLTWH(currentX, 5/2 * rowSize, colSize, rowSize);
  }

  @override
  void render(Canvas canvas) {
    Fonts.menuTitle.render(canvas, 'Gravitional Waves', Position(size.width / 2, rowSize), anchor: Anchor.center);
    buttons.forEach((b) => b.render(canvas));
  }

  void tap(Position p) {
    Offset offset = p.toOffset();
    buttons.firstWhere((b) => b.rectGenerator().contains(offset), orElse: () => null)?.action();
  }

  void doNewGame() {
    gameRef.start();
  }

  void doQuit() {
    exit(0);
  }
}