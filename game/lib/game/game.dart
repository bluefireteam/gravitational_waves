import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/extensions.dart';

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
  bool paused = false;

  late Player player;
  late Hud hud;
  late Wall wall;
  late Powerups powerups;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    this.camera.viewport =
        FixedResolutionViewport(Vector2(32, 18) * BLOCK_SIZE);
    this.camera.speed = 50.0;

    hud = Hud();
    powerups = Powerups();
  }

  void preStart() {
    final isFirstTime = GameData.instance.isFirstTime();

    sleeping = true;
    paused = false;

    gravity = GRAVITY_ACC;
    double firstX = -CHUNCK_SIZE / 2.0 * BLOCK_SIZE;
    lastGeneratedX = firstX;
    coins = 0;
    hasUsedExtraLife = false;

    children.clear();
    if (isFirstTime) {
      showTutorial = 0;
      _addBg(Background.tutorial(lastGeneratedX));
    } else {
      showTutorial = -1;
      _addBg(Background.plains(lastGeneratedX));
    }

    add(player = Player());
    camera.followComponent(player, relativeOffset: Anchor(1 / 3, 0));

    add(wall = Wall(firstX - size.x));
    add(Stars());

    rotationManager = RotationManager();
  }

  void start() {
    Analytics.log(
      powerups.enabled ? EventName.START_REVAMPED : EventName.START_CLASSIC,
    );
    sleeping = false;
    powerups.reset();
    generateNextChunck();
    Audio.gameMusic();
  }

  void restart() {
    preStart();
    start();
  }

  Background findBackgroundForX(double x) {
    return children.whereType<Background>().firstWhere((e) => e.containsX(x));
  }

  void generateNextChunck() {
    while (lastGeneratedX < player.x + size.x) {
      Background bg = Background(lastGeneratedX);
      _addBg(bg);

      int amountCoints = 2 + R.nextInt(3);
      final List<Coin> coins = [];
      for (int i = 0; i < amountCoints; i++) {
        Rect spot = bg.findRectFor(bg.columns.randomIdx(R));
        bool top = R.nextBool();
        double x = spot.center.dx;
        double yOffset = Coin.SIZE / 2;
        double y = top ? spot.top + yOffset : spot.bottom - yOffset;
        if (coins.any((c) => c.overlaps(x, y))) {
          continue;
        }
        Coin c = Coin(x, y);
        coins.add(c);
        add(c);
      }
    }
  }

  void _addBg(Background bg) {
    add(bg);
    lastGeneratedX = bg.endX;
  }

  int get score => player.x ~/ 100;

  void doShowTutorial() {
    add(tutorial = Tutorial());
    pause();
  }

  @override
  void update(double t) {
    if (paused) {
      tutorial?.update(t);
      return;
    }

    super.update(t);
    if (showTutorial > -1 && player.x >= Tutorial.positions[showTutorial]) {
      doShowTutorial();
      showTutorial++;
      if (showTutorial > 1) {
        showTutorial = -1;
      }
    }

    if (!sleeping) {
      maybeGeneratePlanet(t);
      powerups.update(t);
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
    paused = true;
    showGameOver?.call(false);
    sleeping = false;
  }

  @override
  void render(Canvas canvas) {
    renderComponents(canvas);
    if (!sleeping) {
      hud.render(canvas);
    }
    if (paused) {
      bool showMessage = tutorial == null;
      PauseOverlay.render(canvas, size, showMessage);
    }
  }

  void renderComponents(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(rotationManager.angle);
    canvas.translate(-size.x / 2, -size.y / 2);
    super.render(canvas);
    canvas.restore();
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
    if (paused) {
      bool isTutorial = tutorial != null;
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
    if (sleeping || paused) {
      return;
    }
    paused = true;
  }

  void resume() {
    tutorial?.removeFromParent();
    tutorial = null;
    paused = false;
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

    if (score != null && coins != null) {
      GameData.instance.addCoins(coins);
      ScoreBoard.submitScore(score);
    }

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
