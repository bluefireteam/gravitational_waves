import 'package:flame/components.dart';

import '../../collections.dart';
import '../../game.dart';
import '../../util.dart';

class FiringShip extends SpriteAnimationComponent with HasGameRef<MyGame> {
  static const S = 2.0;
  static const TX_W = 80.0;
  static const TX_H = 48.0;
  static const APPROXIMATION_TIME = 2.0;
  static const FIRING_TIME = 4.0;

  double myScale = 0;
  double clock = 0.0;

  late List<double> beforeHoleScales, afterHoleScales;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await SpriteAnimation.load(
      'firing-ship.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(TX_W, TX_H),
        stepTime: 0.15,
      ),
    )
      ..loop = true;

    size = Vector2(S * TX_W, S * TX_H);
    position = gameRef.size / 2;
    anchor = Anchor.center;

    int beforeHoles = R.nextInt(2);
    int afterHoles = 1 + R.nextInt(2);

    final timing = (_) => R.doubleBetween(0.5, 0.85);
    this.beforeHoleScales = List.generate(beforeHoles, timing)..sort();
    this.afterHoleScales = List.generate(afterHoles, timing)..sort();
  }

  @override
  double get width => TX_W * myScale;

  @override
  double get height => TX_H * myScale;

  @override
  void update(double t) {
    this.myScale += (t / APPROXIMATION_TIME);
    this.myScale = this.myScale.clamp(0.0, 1.0);

    if (this.myScale >= 0.5) {
      final pred = (e) => this.myScale > e;
      if (beforeHoleScales.popIf(pred) != null) {
        gameRef.wall.spawnBrokenGlass(before: true);
      }
      if (afterHoleScales.popIf(pred) != null) {
        gameRef.wall.spawnBrokenGlass(before: false);
      }
    }

    if (this.myScale >= 0.8) {
      // tick animation
      super.update(t);
      clock += t;
      y -= SHIPS_SPEED * t;
    }

    if (y < -height) {
      removeFromParent();
      gameRef.powerups.hasSpaceBattle = false;
    }
  }

  @override
  int get priority => 1;

  @override
  bool get isHud => true;
}
