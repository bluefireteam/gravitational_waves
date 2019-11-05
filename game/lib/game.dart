import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';

import 'components/background.dart';
import 'components/player.dart';
import 'palette.dart';
import 'util.dart';

class MyGame extends BaseGame {

  double lastGeneratedX;
  Player player;
  double gravity;

  Size rawSize, scaledSize;
  Position resizeOffset = Position.empty();
  double scale = 2.0;

  MyGame(Size size) {
    resize(size);

    this.lastGeneratedX = -CHUNCK_SIZE / 2.0 * BLOCK_SIZE;
    _addBg(Background.plains(lastGeneratedX));

    this.gravity = GRAVITY_ACC;

    add(player = Player());
    generateNextChunck();
  }

  void generateNextChunck() {
    while (lastGeneratedX < player.x + size.width) {
      _addBg(Background(lastGeneratedX));
    }
  }

  void _addBg(Background bg) {
    add(bg);
    lastGeneratedX = bg.endX;
  }

  void recalculateScaleFactor(Size rawSize) {
    int blocksWidth = 32;
    int blocksHeight = 18;

    double width = blocksWidth * BLOCK_SIZE;
    double height = blocksHeight * BLOCK_SIZE;

    double scaleX = rawSize.width / width;
    double scaleY = rawSize.height / height;

    this.scale = math.min(scaleX, scaleY);

    this.rawSize = rawSize;
    this.size = Size(width, height);
    this.scaledSize = Size(scale * width, scale * height);
    this.resizeOffset = Position((rawSize.width - scaledSize.width) / 2, (rawSize.height - scaledSize.height) / 2);
  }

  @override
  void resize(Size rawSize) {
    recalculateScaleFactor(rawSize);
    super.resize(size);
  }

  @override
  void update(double t) {
    super.update(t);
    generateNextChunck();

    camera.x = player.x - size.width / 3;
  }

  @override
  void render(Canvas c) {
    c.save();
    c.translate(resizeOffset.x, resizeOffset.y);
    c.scale(scale, scale);

    renderGame(c);

    c.restore();
    c.drawRect(Rect.fromLTWH(0.0, 0.0, rawSize.width, resizeOffset.y), Palette.black.paint);
    c.drawRect(Rect.fromLTWH(0.0, resizeOffset.y + scaledSize.height, rawSize.width, resizeOffset.y), Palette.black.paint);
    c.drawRect(Rect.fromLTWH(0.0, 0.0, resizeOffset.x, rawSize.height), Palette.black.paint);
    c.drawRect(Rect.fromLTWH(resizeOffset.x + scaledSize.width, 0.0, resizeOffset.x, rawSize.height), Palette.black.paint);
  }

  void renderGame(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), Palette.black.paint);
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpDetails details) {
    super.onTapUp(details);
    gravity *= -1;
  }

  void pause() {}
}