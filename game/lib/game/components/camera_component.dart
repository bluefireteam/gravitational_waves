 
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/position.dart';

abstract class CameraComponent<T extends BaseGame> extends Component with Resizable, HasGameRef<T> {

  Position currentCameraDelta = Position.empty();
  Position targetCameraDelta = Position.empty();

  double shakeTimer = 0.0;
  double shakeAmount = 0.0;

  final double cameraSpeed;

  CameraComponent(this.cameraSpeed);

  double getCameraX();
  double getCameraY();

  @override
  void update(double dt) {
    if (currentCameraDelta != targetCameraDelta) {
      final ds = cameraSpeed * dt;
      final Position diff = targetCameraDelta.clone().minus(currentCameraDelta);
      if (diff.length() < ds) {
        currentCameraDelta = targetCameraDelta.clone();
      } else {
        currentCameraDelta = currentCameraDelta.add(diff.scaleTo(ds));
      }
    }

    double cameraX = getCameraX() ?? 0;
    double cameraY = getCameraY() ?? 0;

    gameRef.camera.x = cameraX + currentCameraDelta.x + _shakeDelta();
    gameRef.camera.y = cameraY + currentCameraDelta.y + _shakeDelta();

    if (shaking) {
      shakeTimer -= dt;
      if (shakeTimer < 0.0) {
        shakeTimer = 0.0;
      }
    }
  }

  bool get shaking => shakeTimer > 0.0;

  double _shakeDelta() {
    if (shaking) {
      return math.Random.secure().nextDouble() * shakeAmount;
    }
    return 0.0;
  }

  void reset() {
    targetCameraDelta = Position.empty();
  }

  void moveTo(Position p) {
    targetCameraDelta.x = p.x;
    targetCameraDelta.y = p.y;
  }

  void shake({ double duration = 0.2, double shakeAmount = 25 }) {
    shakeTimer += duration;
    this.shakeAmount = shakeAmount;
  }

  @override
  void render(Canvas c) {}

  @override
  int priority() => 100000; // TODO figure out how to properly do this
}