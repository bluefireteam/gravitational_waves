import 'dart:ui';

import 'package:flame/position.dart';

import '../game.dart';
import 'page.dart';

class TitlePage extends Page {
  TitlePage(MyGame gameRef) : super(gameRef);

  @override
  void render(Canvas canvas) {
    // TODO render menu
  }

  void tap(Position p) {
    // TODO handle menu items
    gameRef.start();
  }
}