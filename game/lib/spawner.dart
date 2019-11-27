import 'dart:math' as math;

class Spawner {
  static final math.Random _r = math.Random();

  double chance;

  Spawner(this.chance);

  bool tossCoin(double dt) {
    return _r.nextDouble() * dt <= chance;
  }

  void maybeSpawn(double dt, Function() action) {
    if (tossCoin(dt)) action();
  }
}