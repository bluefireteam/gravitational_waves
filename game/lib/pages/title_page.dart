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

  double get colSize => size.width / (2 * buttons.length + 1);
  double get rowSize => size.height / 4;

  Rect getRectAt(int idx) {
    final currentX = (2 * idx + 1) * colSize;
    return Rect.fromLTWH(currentX, 5/2 * rowSize, colSize, rowSize);
  }

  @override
  bool fullScreen = true;

  @override
  void render(Canvas canvas) {
    Fonts.menuTitle.render(canvas, 'Gravitional Waves', Position(size.width / 2, rowSize), anchor: Anchor.center);
    buttons.forEach((b) => b.render(canvas));
  }

  @override
  void tap(Position p) => Button.handleTap(buttons, p);

  void doNewGame() {
    gameRef.start();
  }

  void doQuit() {
    exit(0);
  }
}