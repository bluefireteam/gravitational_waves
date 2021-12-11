import 'collections.dart';
import 'spawner.dart';
import 'util.dart';

class RotationManager {
  static final prob = [-1, 0, 0, 1];

  Spawner changeSpeed = Spawner(0.2);

  double _clock = 0.0;
  double angle = 0.0;
  double angularSpeed = 0.0;

  void tick(double dt) {
    _clock += dt;
    angle += angularSpeed * dt;
    if (_clock > 3.0) {
      changeSpeed.maybeSpawn(
        dt,
        () => angularSpeed = ROTATION_SPEED * prob.sample(R),
      );
    }
  }
}
