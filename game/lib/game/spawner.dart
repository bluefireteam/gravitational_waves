import 'util.dart';

class Spawner {
  double chance; // chance per second

  Spawner(this.chance);

  bool tossCoin(double dt) {
    print(R.nextDouble() / dt);
    return R.nextDouble() / dt < chance;
  }

  void maybeSpawn(double dt, Function() action) {
    if (tossCoin(dt)) action();
  }
}
