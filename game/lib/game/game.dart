import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'analytics.dart';
import 'audio.dart';
import 'collections.dart';
import 'components/background.dart';
import 'components/coin.dart';
import 'components/hud.dart';
import 'components/planet.dart';
import 'components/player.dart';
import 'components/revamped/powerups.dart';
import 'components/stars.dart';
import 'components/tutorial.dart';
import 'components/wall.dart';
import 'game_data.dart';
import 'palette.dart';
import 'pause_overlay.dart';
import 'rotation_manager.dart';
import 'rumble.dart';
import 'scoreboard.dart';
import 'spawner.dart';
import 'util.dart';

class MyGame extends FlameGame with TapDetector {
  static Spawner planetSpawner = Spawner(0.12);

  // Setup by the flutter components to allow this game instance
  // to callback to the flutter code and go back to the menu
  void Function()? backToMenu;

  void Function(bool)? showGameOver;

  late RotationManager rotationManager;
  late double lastGeneratedX;
  late double gravity;
  int coins = 0;
  bool hasUsedExtraLife = false;

  /* -1 : do not show, 0: show first, 1: show second */
  late int showTutorial;
  Tutorial? tutorial;

  bool sleeping = false;
  bool gamePaused = false;
  bool enablePowerups = false;

  late Player player;
  late Hud hud;
  late Wall wall;
  late Powerups powerups;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      Vector2(32, 18) * BLOCK_SIZE,
      noClip: true,
    );
    camera.speed = 50.0;

    await preStart();
  }

  Future<void> preStart() async {
    final isFirstTime = GameData.instance.isFirstTime();

    sleeping = true;
    gamePaused = false;

    gravity = GRAVITY_ACC;
    const firstX = -CHUNK_SIZE / 2.0 * BLOCK_SIZE;
    lastGeneratedX = firstX;
    coins = 0;
    hasUsedExtraLife = false;

    children.clear();
    if (isFirstTime) {
      showTutorial = 0;
      await _addBg(Background.tutorial(lastGeneratedX));
    } else {
      showTutorial = -1;
      await _addBg(Background.plains(lastGeneratedX));
    }

    add(powerups = Powerups());
    await add(player = Player());
    updateCamera();

    await add(wall = Wall(firstX - size.x));
    await add(Stars());

    rotationManager = RotationManager();
  }

  void updateCamera() {
    camera.snapTo(Vector2(player.position.x - size.x / 3, 0));
  }

  void start(bool enablePowerups) {
    this.enablePowerups = enablePowerups;
    Analytics.log(
      enablePowerups ? EventName.START_REVAMPED : EventName.START_CLASSIC,
    );
    sleeping = false;
    add(hud = Hud());
    powerups.reset();
    generateNextChunck();
    Audio.gameMusic();
  }

  Future<void> restart() async {
    await preStart();
    start(enablePowerups);
  }

  Background findBackgroundForX(double x) {
    return children.whereType<Background>().firstWhere((e) => e.containsX(x));
  }

  Future<void> generateNextChunck() async {
    while (lastGeneratedX < player.x + size.x) {
      final bg = Background(lastGeneratedX);
      await _addBg(bg);

      final coinLevel = Coin.computeCoinLevel(
        x: lastGeneratedX,
        powerups: enablePowerups,
      );
      final amountCoints = R.nextInt(1 + coinLevel);
      final coins = <Coin>[];
      for (var i = 0; i < amountCoints; i++) {
        final spot = bg.findRectFor(bg.columns.randomIdx(R));
        final top = R.nextBool();
        final x = spot.center.dx;
        const yOffset = Coin.SIZE / 2;
        final y = top ? spot.top + yOffset : spot.bottom - yOffset;
        if (coins.any((c) => c.overlaps(x, y))) {
          continue;
        }
        final c = Coin(x, y);
        coins.add(c);
        await add(c);
      }
    }
  }

  Future<void> _addBg(Background bg) async {
    await add(bg);
    lastGeneratedX = bg.endX;
    // we need to make sure the bg is actually added so
    // it can be found by other components
    children.updateComponentList();
  }

  int get score => player.x ~/ 100;

  Future<void> doShowTutorial() async {
    pause();
    await add(tutorial = Tutorial());
    children.updateComponentList();
  }

  @override
  void update(double t) {
    if (gamePaused) {
      tutorial?.update(t);
      return;
    }

    super.update(t);
    updateCamera();

    if (showTutorial > -1 && player.x >= Tutorial.positions[showTutorial]) {
      doShowTutorial();
      showTutorial++;
      if (showTutorial > 1) {
        showTutorial = -1;
      }
    }

    if (!sleeping) {
      maybeGeneratePlanet(t);
      generateNextChunck();
      rotationManager.tick(t);
    }
  }

  void maybeGeneratePlanet(double dt) {
    planetSpawner.maybeSpawn(dt, () => add(Planet()));
  }

  void gainExtraLife() {
    hasUsedExtraLife = true;
    player.extraLife();
    gamePaused = true;
    showGameOver?.call(false);
    sleeping = false;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Vector2.zero() & canvasSize, Palette.background.paint());
    canvas.save();
    canvas.translate(canvasSize.x / 2, canvasSize.y / 2);
    canvas.rotate(rotationManager.angle);
    canvas.translate(-canvasSize.x / 2, -canvasSize.y / 2);
    super.render(canvas);
    canvas.restore();

    if (gamePaused) {
      final showMessage = tutorial == null;
      PauseOverlay.render(canvas, canvasSize, showMessage);
    }
  }

  @override
  void onTapDown(TapDownInfo details) {
    if (player.regularJetpack) {
      player.hoverStart();
    }
  }

  @override
  void onTapUp(TapUpInfo details) {
    if (sleeping) {
      return;
    }
    if (gamePaused) {
      final isTutorial = tutorial != null;
      resume();
      if (!isTutorial) {
        return;
      }
    }
    super.onTapUp(details);
    if (showTutorial == 0) {
      showTutorial = -1; // if the player jumps don't show the tutorial
    }
    if (player.jetpack) {
      player.boost();
    } else {
      gravity *= -1;
    }
  }

  void pause() {
    Audio.pauseMusic();
    if (sleeping || gamePaused) {
      return;
    }
    gamePaused = true;
  }

  void resume() {
    tutorial?.removeFromParent();
    tutorial = null;
    gamePaused = false;
    Audio.resumeMusic();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      pause();
    } else {
      Audio.resumeMusic();
    }
  }

  void gameOver() async {
    Audio.die();
    Audio.stopMusic();

    GameData.instance.addCoins(coins);
    ScoreBoard.submitScore(score);

    sleeping = true;
    showGameOver?.call(true);
  }

  void collectCoin() {
    coins++;
    Audio.coin();
  }

  void vibrate() {
    Rumble.rumble();
    camera.shake();
  }
}
