import 'dart:ui';

import 'package:flame/text_config.dart';

import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'button.dart';
import 'page.dart';
import 'title_page.dart';
import 'with_buttons.dart';

class GameOverPage extends Page with WithButtons {

  static final Paint _bgPaint = Palette.black.paint;
  static final Paint _bgBorder = Palette.white.paint..style = PaintingStyle.stroke..strokeWidth = 2;

  @override
  List<Button> buttons;

  GameOverPage(MyGame gameRef) : super(gameRef) {
    buttons = [
      Button('Restart', () => getRectAt(0), doRestart),
      Button('Main Menu', () => getRectAt(1), doMainMenu),
    ];
  }

  @override
  TextConfig font = Fonts.gameOverItems;

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
    canvas.drawRect(background, _bgPaint);
    canvas.drawRect(background.deflate(4.0), _bgBorder);

    renderButtons(canvas);
  }

  void doRestart() {
    gameRef.start();
  }

  void doMainMenu() {
    gameRef.currentPage = TitlePage(gameRef);
    gameRef.components.clear();
  }
}