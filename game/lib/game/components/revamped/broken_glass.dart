import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../../assets/poofs.dart';
import '../../game.dart';
import '../../util.dart';

class BrokenGlass extends PositionComponent with HasGameRef<MyGame> {
  static final Vector2 deltaCenter = Vector2.all(BLOCK_SIZE) / 2;

  SpriteAnimation animation = Poofs.airEscaping();
  SpriteAnimation initialAnimation = Poofs.glassBreaking();

  BrokenGlass(double x, double y) {
    this.x = x;
    this.y = y;
    width = height = BLOCK_SIZE;
  }

  @override
  void render(Canvas c) {
    super.render(c);
    if (!initialAnimation.done()) {
      initialAnimation
          .getSprite()
          .render(c, position: deltaCenter, anchor: Anchor.center);
    }
    animation.getSprite().render(c);
  }

  @override
  void update(double t) {
    super.update(t);
    initialAnimation.update(t);
    animation.update(t);

    final player = gameRef.player.toRect();
    final rect = toRect();
    if (player.overlaps(rect)) {
      gameRef.player.suck(rect.center.toVector2());
    }

    if (x < gameRef.camera.position.x) {
      removeFromParent();
    }
  }
}
