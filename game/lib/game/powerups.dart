import 'components/revamped/firing_ship.dart';
import 'components/revamped/space_battle.dart';
import 'game.dart';
import 'spawner.dart';

class Powerups {
  static Spawner spaceBattleSpawner = Spawner(0.000005);

  MyGame game;
  bool enabled = false;

  bool hasSpaceBattle;

  Powerups(this.game);

  void reset() {
    hasSpaceBattle = false;
  }

  void maybeGeneratePowerups(double dt) {
    if (!enabled) {
      return;
    }

    if (!hasSpaceBattle) {
      spaceBattleSpawner.maybeSpawn(dt, () {
        hasSpaceBattle = true;
        game.addLater(SpaceBattle(game.size));
      });
    }
  }

  void spawnFiringShip() {
    if (!game.sleeping) {
      game.addLater(FiringShip(game.size));
    }
  }

  void spawnGlassHoles() {
    hasSpaceBattle = false;
    if (!game.sleeping) {
      // TODO add holes
    }
  }
}
