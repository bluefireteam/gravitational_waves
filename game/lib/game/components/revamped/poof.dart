import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../../assets/poofs.dart';
import '../../game.dart';

class Poof extends AnimationComponent with HasGameRef<MyGame> {
  static const double SIZE = 16.0;

  Poof(double x, double y) : super(SIZE, SIZE, Poofs.poof()) {
    this.destroyOnFinish = true;
    this.x = x - SIZE / 2;
    this.y = y - SIZE / 2;
  }

  @override
  int priority() => 5;
}
