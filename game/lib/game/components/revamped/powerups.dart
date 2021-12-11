import 'package:dartlin/collections.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../../collections.dart';
import '../../game.dart';
import '../../spawner.dart';
import '../../util.dart';
import '../background.dart';
import 'crystal_container_pickup.dart';
import 'firing_ship.dart';
import 'jetpack_pickup.dart';
import 'space_battle.dart';

class Powerups extends Component with HasGameRef<MyGame> {
  static Spawner spaceBattleSpawner = Spawner(0.015);
  static Spawner jetpackSpawner = Spawner(0.5);
  static Spawner crystalContainerSpawner = Spawner(0.15);

  bool enabled = false;
  bool hasSpaceBattle = false;

  Powerups();

  void reset() {
    hasSpaceBattle = false;
  }

  @override
  void update(double dt) {
    if (gameRef.sleeping) {
      return;
    }
    super.update(dt);
    _maybeGeneratePowerups(dt);
  }

  void _maybeGeneratePowerups(double dt) {
    if (!enabled) {
      return;
    }

    if (!hasSpaceBattle) {
      spaceBattleSpawner.maybeSpawn(dt, () {
        hasSpaceBattle = true;
        gameRef.add(SpaceBattle());
      });
    }

    jetpackSpawner.maybeSpawn(dt, () {
      Vector2? p = maybeGetOffscreenPosition();
      if (p != null) {
        final type = JetpackType.values.sample(R);
        gameRef.add(JetpackPickup(type, p.x, p.y));
      }
    });

    crystalContainerSpawner.maybeSpawn(dt, () {
      Vector2? p = maybeGetOffscreenPosition();
      if (p != null) {
        gameRef.add(CrystalContainerPickup(p.x, p.y));
      }
    });
  }

  Vector2? maybeGetOffscreenPosition() {
    double offscreenX = gameRef.camera.position.x + gameRef.size.x + 1;
    Background? firstOffscreen = gameRef.children
        .whereType<Background>()
        .firstOrNull((c) => c.x > offscreenX);
    if (firstOffscreen == null) {
      return null;
    }
    int idx = firstOffscreen.columns.randomIdx(R);
    double x = firstOffscreen.x + (idx + 0.5) * BLOCK_SIZE;
    double y = firstOffscreen.columns[idx].randomYHeight() + BLOCK_SIZE / 2;
    return Vector2(x, y);
  }

  void spawnFiringShip() {
    if (!gameRef.sleeping) {
      gameRef.add(FiringShip());
    }
  }
}
