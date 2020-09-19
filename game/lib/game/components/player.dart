import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import '../assets/char.dart';
import '../game.dart';
import '../game_data.dart';
import '../palette.dart';
import '../rumble.dart';
import '../util.dart';
import 'background.dart';
import 'player_particles.dart';
import 'revamped/jetpack_pickup.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  static const HURT_TIMER = 2.0;
  static const SHINE_TIMER = 0.25;

  double speedY;
  int livesLeft;

  double hurtTimer, shinyTimer, invulnerabilityTimer;
  double jetpackTimeout;

  PlayerParticles particles;

  Position suctionCenter;
  double scale = 1.0;

  Player() {
    this.x = 0.0;
    this.width = this.height = BLOCK_SIZE;
    this.speedY = 0.0;
    this.livesLeft = STARTING_LIVES;
    this.particles = PlayerParticles();
    reset();
  }

  void reset() {
    scale = 1.0;
    hurtTimer = 0.0;
    shinyTimer = 0.0;
    invulnerabilityTimer = 0;
    jetpackTimeout = 0.0;
  }

  void extraLife() {
    reset();
    livesLeft++;
    hurtTimer = 0.5;
    invulnerabilityTimer = 0.5; // start with half a second of invulnerability
  }

  bool get shouldFlip => gameRef.gravity > 0;

  bool get hurt => hurtTimer > 0.0;

  bool get invulnerable => invulnerabilityTimer > 0.0;

  bool get shiny => shinyTimer > 0.0;

  bool get dead => livesLeft == 0;

  bool get jetpack => jetpackTimeout > 0.0;

  Paint get _paint {
    if (shiny) {
      return Paint()
        ..colorFilter =
            ColorFilter.mode(Palette.playerShine.color, BlendMode.srcATop);
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

    double scaledW = skin.size.x * scale;
    double scaledH = skin.size.y * scale;
    double dX = (skin.size.x - scaledW) / 2;
    double dY = (skin.size.y - scaledH) / 2;

    Rect realRect = toRect();
    double drawX = x - (skin.size.x - realRect.width) / 2 + dX;
    double drawY =
        y - (shouldFlip ? (skin.size.y - realRect.height) : 0.0) + dY;
    Rect renderRect = Rect.fromLTWH(0, 0, scaledW, scaledH);

    c.save();
    c.translate(drawX, drawY);

    if (jetpack) {
      double dy = shouldFlip ? height : 0.0;
      JetpackPickup.jetpack.renderPosition(c, Position(-1, dy));
    }

    if (angle == 0) {
      c.translate(0, renderRect.height / 2);
      c.scale(1.0, 1.0 * (shouldFlip ? 1.0 : -1.0));
      c.translate(0, -renderRect.height / 2);
    } else {
      c.translate(renderRect.width / 2, renderRect.height / 2);
      c.rotate(angle);
      c.translate(-renderRect.width / 2, -renderRect.height / 2);
    }
    skin.renderRect(c, renderRect, overridePaint: _paint);
    c.restore();

    renderParticles(c);

    if (DEBUG) {
      c.drawRect(
        getCurrentRect(),
        Palette.playerDebugRect.paint..style = PaintingStyle.stroke,
      );
    }
  }

  void renderParticles(Canvas c) {
    c.save();
    c.translate(x, shouldFlip ? y : y - BLOCK_SIZE);
    particles.render(c, !jetpack);
    c.restore();
  }

  void shine() {
    shinyTimer = SHINE_TIMER;
  }

  void suck(Position center) {
    this.suctionCenter = center;
    this.jetpackTimeout = 0.0;
  }

  void boost() {
    speedY -= gameRef.gravity.sign * 300;
    particles.jetpackBoost();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.sleeping) {
      hurtTimer = shinyTimer = 0.0;
      return;
    }

    if (hurt) {
      hurtTimer -= dt;
    }
    if (shiny) {
      shinyTimer -= dt;
    }
    if (jetpack) {
      jetpackTimeout -= dt;
    }
    if (invulnerable) {
      invulnerabilityTimer -= dt;
    }

    if (suctionCenter != null) {
      bool isThereYet = moveToCenter(suctionCenter, SUCTION_SPEED, dt);
      if (scale == 0.001) {
        gameRef.gameOver();
      } else if (isThereYet) {
        scale -= dt;
        scale = scale.clamp(0.001, 1.0);

        angle += dt;
      }

      return;
    }

    particles.update(dt);

    x += dt * PLAYER_SPEED;

    final blockRect = getCurrentRect();

    if (!invulnerable && (y < blockRect.top || y > blockRect.bottom - height)) {
      livesLeft--;
      Rumble.rumble();
      if (livesLeft > 0) {
        hurtTimer = HURT_TIMER;
      } else {
        gameRef.gameOver();
      }
    }

    double accY = gameRef.gravity * (jetpack ? 0.5 : 1.0);
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

  Position toCenter() => Position.fromOffset(this.toRect().center);

  // maybe abstract to position component?
  bool moveToCenter(
    Position goal,
    double speed,
    double dt, {
    double treshold = 0.001,
  }) {
    if (goal.x - width / 2 == x && goal.y - height / 2 == y) return true;

    Position displacement = toCenter().minus(goal);
    double prevDist = displacement.length();
    if (prevDist < treshold) {
      x = goal.x - width / 2;
      y = goal.y - height / 2;
      return true;
    }

    Position delta = displacement.scaleTo(speed * dt);
    x += delta.x;
    y += delta.y;

    double newDist = toCenter().minus(goal).length();
    if (newDist < treshold || newDist > prevDist) {
      // right there or overshoot, correct
      x = goal.x - width / 2;
      y = goal.y - height / 2;
      return true;
    }

    return false;
  }
}
