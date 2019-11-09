import 'dart:ui';

import 'package:flame/position.dart';
import 'package:gravitational_waves/pages/title_page.dart';

import '../game.dart';
import '../palette.dart';
import 'button.dart';
import 'page.dart';

class GameOverPage extends Page {

  List<Button> buttons;

  GameOverPage(MyGame gameRef) : super(gameRef) {
    buttons = [
      Button('Restart', () => getRectAt(0), doRestart),
      Button('Main Menu', () => getRectAt(1), doMainMenu),
    ];
  }

  Rect get background => Rect.fromLTWH(size.width / 4, size.height / 4, size.width / 2, size.height / 2);
  double get colSize => background.width / (2 * buttons.length + 1);
  double get rowSize => background.height / 2;

  Rect getRectAt(int idx) {
    final x = background.left + (2 * idx + 1) * colSize;
    final y = background.top + background.height / 4;
    return Rect.fromLTWH(x, y, colSize, rowSize);
  }

  @override
  bool fullScreen = false;

  @override
  void render(Canvas canvas) {
    final bg = Rect.fromLTWH(size.width / 4, size.height / 4, size.width / 2, size.height / 2);
    canvas.drawRect(bg, Palette.black.paint);
    buttons.forEach((b) => b.render(canvas));
  }

  @override
  void tap(Position p) => Button.handleTap(buttons, p);

  void doRestart() {
    gameRef.start();
  }

  void doMainMenu() {
    gameRef.currentPage = TitlePage(gameRef);
    gameRef.components.clear();
  }
}