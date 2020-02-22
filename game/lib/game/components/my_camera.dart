import '../game.dart';
import 'camera_component.dart';

class MyCamera extends CameraComponent<MyGame> {
  static const CAMERA_SPEED = 50.0;

  MyCamera() : super(CAMERA_SPEED);

  @override
  double getCameraX() => gameRef.player.x - size.width / 3;

  @override
  double getCameraY() => 0;
}