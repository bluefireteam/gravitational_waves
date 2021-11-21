import 'package:flame/components.dart';

import '../assets/tileset.dart';
import '../collections.dart';
import '../game.dart';
import '../util.dart';

class Planet extends SpriteComponent with HasGameRef<MyGame> {
  Planet() {
    this.sprite = Tileset.planets.sample(R);
    this.width = sprite!.srcSize.x;
    this.height = sprite!.srcSize.y;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    this.x = gameRef.size.x + width;
    this.y = R.nextDouble() * (gameRef.size.y - height);
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= PLANET_SPEED * t;

    if (x < -width) {
      removeFromParent();
    }
  }

  @override
  int get priority => 1;

  @override
  bool get isHud => true;
}
