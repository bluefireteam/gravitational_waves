import 'package:flame/components.dart';

import '../../assets/poofs.dart';
import '../../game.dart';

class Poof extends SpriteAnimationComponent with HasGameRef<MyGame> {
  static const double SIZE = 16.0;

  Poof(double x, double y)
      : super(
          animation: Poofs.poof(),
          removeOnFinish: true,
          size: Vector2.all(SIZE),
          position: Vector2(x, y) - Vector2.all(SIZE) / 2,
        );

  @override
  int get priority => 5;
}
