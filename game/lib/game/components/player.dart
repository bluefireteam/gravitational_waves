import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/sprite.dart';

import '../assets/char.dart';
import '../game.dart';
import '../game_data.dart';
import '../palette.dart';
import '../rumble.dart';
import '../util.dart';
import 'background.dart';
import 'player_particles.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  static const HURT_TIMER = 2.0;
  static const SHINE_TIMER = 0.25;

  double speedY;
  int livesLeft;
  double hurtTimer, shinyTimer;

  PlayerParticles particles;

  Player() {
    this.x = 0.0;
    this.width = this.height = BLOCK_SIZE;
    this.speedY = 0.0;
    this.livesLeft = 1;
    this.hurtTimer = 0.0;
    this.shinyTimer = 0.0;
    this.particles = PlayerParticles();
  }

  bool get shouldFlip => gameRef.gravity > 0;

  bool get hurt => hurtTimer > 0.0;

  bool get shiny => shinyTimer > 0.0;

  bool get dead => livesLeft == 0;

  Paint get _paint {
    if (shiny) {
      return Paint()..colorFilter = ColorFilter.mode(Palette.playerShine.color, BlendMode.srcATop);
    }
    final blinkHurt = hurt && (hurtTimer * 1000) % 250 > 125;
    final palette = blinkHurt ? Palette.playerHurt : Palette.player;
    return palette.paint;
  }

  @override
  set gameRef(MyGame gameRef) {
    super.gameRef = gameRef;
    this.y = getCurrentRect().bottom - BLOCK_SIZE;
  }

  @override
  void render(Canvas c) {
    Sprite skin = Char.fromSkin(GameData.instance.selectedSkin);
    if (!skin.loaded()) return;

    Rect realRect = toRect();
    double drawX = x - (skin.size.x - realRect.width) / 2;
    double drawY = y - (shouldFlip ? (skin.size.y - realRect.height) : 0);
    Rect renderRect = Rect.fromLTWH(0, 0, skin.size.x, skin.size.y);

    c.save();
    c.translate(drawX, drawY);
    c.translate(0, renderRect.height / 2);
    c.scale(1.0, shouldFlip ? 1.0 : -1.0);
    c.translate(0, -renderRect.height / 2);
    skin.renderRect(c, renderRect, overridePaint: _paint);
    c.restore();

    renderParticles(c);

    if (DEBUG) {
      c.drawRect(getCurrentRect(),
          Palette.playerDebugRect.paint..style = PaintingStyle.stroke);
    }
  }

  void renderParticles(Canvas c) {
    c.save();
    c.translate(x, shouldFlip ? y : y - BLOCK_SIZE);
    particles.render(c);
    c.restore();
  }

  void shine() {
    shinyTimer = SHINE_TIMER;
  }

  @override
  void update(double dt) {
    if (gameRef.sleeping) {
      return;
    }

    particles.update(dt);

    if (hurt) {
      hurtTimer -= dt;
    }
    if (shiny) {
      shinyTimer -= dt;
    }

    x += dt * PLAYER_SPEED;

    final blockRect = getCurrentRect();

    if (y < blockRect.top || y > blockRect.bottom - height) {
      livesLeft--;
      Rumble.rumble();
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
  int priority() => 5;
}
