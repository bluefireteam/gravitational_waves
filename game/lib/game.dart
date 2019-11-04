
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'components/background.dart';
import 'components/player.dart';
import 'palette.dart';

class MyGame extends BaseGame {

  double lastGeneratedX;
  Player player;

  MyGame(Size size) {
    this.size = size;
    this.lastGeneratedX = -size.width;

    start(size);
  }

  void start(Size size) {
    add(player = Player(size));
    generateNextChunck();
  }

  void generateNextChunck() {
    while (lastGeneratedX < player.x + size.width) {
      final bg = Background(lastGeneratedX);
      add(bg);
      lastGeneratedX = bg.endX;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    generateNextChunck();

    camera.x = player.x - size.width / 3;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), Palette.black.paint);
    super.render(canvas);
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
  }

  void pause() {}
}