
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'components/background.dart';
import 'components/player.dart';

class MyGame extends BaseGame {

  double lastGeneratedX = -Background.CHUNCK_SIZE.toDouble();
  Player player;

  MyGame(Size size) {
    this.size = size;

    start();
  }

  void start() {
    add(player = Player());
    generateNextChunck();
  }

  void generateNextChunck() {
    while (lastGeneratedX < (player.x / size.width) + Background.CHUNCK_SIZE) {
      add(Background(lastGeneratedX));
      lastGeneratedX += Background.CHUNCK_SIZE;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    generateNextChunck();

    camera.x = player.x - size.width / 3;
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
  }

  void pause() {}
}