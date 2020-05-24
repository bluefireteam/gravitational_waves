import 'package:flame/position.dart';

import '../../collections.dart';
import '../../game.dart';
import '../../spawner.dart';
import '../../util.dart';
import '../background.dart';
import 'crystal_container_pickup.dart';
import 'firing_ship.dart';
import 'jetpack_pickup.dart';
import 'space_battle.dart';

class Powerups {
  static Spawner spaceBattleSpawner = Spawner(0.15);
  static Spawner jetpackSpawner = Spawner(0.15);
  static Spawner crystalContainerSpawner = Spawner(0.15);

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
      Position p = maybeGetOffscreenPosition();
      if (p != null) {
        game.addLater(JetpackPickup(p.x, p.y));
      }
    });

    crystalContainerSpawner.maybeSpawn(dt, () {
      Position p = maybeGetOffscreenPosition();
      if (p != null) {
        game.addLater(CrystalContainerPickup(p.x, p.y));
      }
    });
  }

  Position maybeGetOffscreenPosition() {
    double offscreenX = game.camera.x + game.size.width + 1;
    Background firstOffscreen = game.components.firstOrNull((c) => c is Background && c.x > offscreenX);
    if (firstOffscreen == null) {
      return null;
    }
    int idx = firstOffscreen.columns.randomIdx(R);
    double x = firstOffscreen.x + (idx + 0.5) * BLOCK_SIZE;
    double y = firstOffscreen.columns[idx].randomYHeight() + BLOCK_SIZE / 2;
    return Position(x, y);
  }

  void spawnFiringShip() {
    if (!game.sleeping) {
      game.addLater(FiringShip(game.size));
    }
  }
}
