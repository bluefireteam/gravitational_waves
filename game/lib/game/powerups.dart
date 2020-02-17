import 'package:gravitational_waves/game/components/revamped/jetpack_pickup.dart';

import 'components/background.dart';
import 'components/revamped/firing_ship.dart';
import 'components/revamped/space_battle.dart';
import 'game.dart';
import 'spawner.dart';
import 'util.dart';
import 'collections.dart';

class Powerups {
  static Spawner spaceBattleSpawner = Spawner(0.000005);
  static Spawner jetpackSpawner = Spawner(0.00001);

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

    jetpackSpawner.maybeSpawn(dt, () {
      double offscreenX = game.camera.x + game.size.width + 1;
      Background firstOffscreen = game.components.firstOrNull((c) => c is Background && c.x > offscreenX);
      if (firstOffscreen != null) {
        int idx = firstOffscreen.columns.randomIdx(R);
        double x = firstOffscreen.x + (idx + 0.5) * BLOCK_SIZE;
        double y = firstOffscreen.columns[idx].randomYHeight() + BLOCK_SIZE / 2;
        game.addLater(JetpackPickup(x, y));
      }
    });
  }

  void spawnFiringShip() {
    if (!game.sleeping) {
      game.addLater(FiringShip(game.size));
    }
  }
}
