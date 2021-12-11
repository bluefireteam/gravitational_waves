import 'package:flame/components.dart';

import '../assets/tileset.dart';
import '../collections.dart';
import '../game.dart';
import '../util.dart';

class Planet extends SpriteComponent with HasGameRef<MyGame> {
  Planet() {
    sprite = Tileset.planets.sample(R);
    width = sprite!.srcSize.x;
    height = sprite!.srcSize.y;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    x = gameRef.size.x + width;
    y = R.nextDouble() * (gameRef.size.y - height);
  }

  @override
  void update(double t) {
    super.update(t);
    x -= PLANET_SPEED * t;

    if (x < -width) {
      removeFromParent();
    }
  }

  @override
  int get priority => 1;

  @override
  PositionType get positionType => PositionType.viewport;
}
