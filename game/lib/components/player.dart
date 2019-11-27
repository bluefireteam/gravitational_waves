import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'background.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {

  static const HURT_TIMER = 2.0;

  double speedY;
  int livesLeft;
  double hurtTimer;

  Player() {
    this.x = 0.0;
    this.width = this.height = BLOCK_SIZE;
    this.speedY = 0.0;
    this.livesLeft = 3 * 1000;
    this.hurtTimer = 0.0;
  }

  bool get hurt => hurtTimer > 0.0;

  bool get dead => livesLeft == 0;

  Paint get _paint {
    final shine = hurt && (hurtTimer * 1000) % 250 > 125;
    final palette = shine ? Palette.playerShine : Palette.player;
    return palette.paint;
  }

  @override
  set gameRef(MyGame gameRef) {
    super.gameRef = gameRef;
    this.y = getCurrentRect().bottom - BLOCK_SIZE;
  }

  @override
  void render(Canvas c) {
    c.drawRect(toRect(), _paint);
    if (DEBUG) {
      c.drawRect(getCurrentRect(), Palette.playerDebugRect.paint..style = PaintingStyle.stroke);
    }
  }

  @override
  void update(double dt) {
    if (hurt) {
      hurtTimer -= dt;
    }

    x += dt * PLAYER_SPEED;

    final blockRect = getCurrentRect();

    if (y < blockRect.top || y > blockRect.bottom - height) {
      livesLeft--;
      if (livesLeft > 0) {
        hurtTimer = HURT_TIMER;
      } else {
        gameRef.gameOver();
      }
    }

    double accY = gameRef.gravity;
    y += accY * dt * dt / 2 + speedY * dt;
    speedY += accY * dt;
    
    if (y < blockRect.top) {
      y = blockRect.top;
      speedY = 0;
    } else if (y > blockRect.bottom - height) {
      y = blockRect.bottom - height;
      speedY = 0;
    }
  }

  Rect getCurrentRect() {
    return gameRef.components
      .where((c) => c is Background)
      .map((c) => c as Background)
      .firstWhere((c) => c.contains(right))
      .findRectContaining(right);
  }

  double get right => x + width;

  @override
  int priority() => 4;
}