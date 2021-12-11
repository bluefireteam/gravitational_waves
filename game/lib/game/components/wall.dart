import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:dartlin/dartlin.dart';

import '../assets/tileset.dart';
import '../collections.dart';
import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'revamped/broken_glass.dart';

class Wall extends PositionComponent with HasGameRef<MyGame> {
  static final Paint _wall = Palette.wall.paint();

  Map<int, int> brokenPanes = {};

  Sprite get wallSprite => Tileset.wall;
  double get w => wallSprite.srcSize.x;
  double get h => wallSprite.srcSize.y;

  double get startY => (gameRef.size.y - h) / 2;

  int currentStartingPane = 0;

  Wall(double x) {
    this.x = x;
    this.y = 0;
  }

  @override
  void render(Canvas c) {
    renderColorBg(c);
    renderWall(c);
    super.render(c);
  }

  void renderColorBg(Canvas c) {
    c.renderAt(gameRef.camera.position - position, (c) {
      final topBar = Rect.fromLTWH(
        -gameRef.size.x / 2,
        0.0,
        2 * gameRef.size.x,
        startY,
      );
      final bottomBar = Rect.fromLTWH(
        -gameRef.size.x / 2,
        (gameRef.size.y + h) / 2,
        2 * gameRef.size.x,
        startY,
      );
      c.drawRect(topBar, _wall);
      c.drawRect(bottomBar, _wall);
    });
  }

  void renderWall(Canvas c) {
    double dx = 0;
    int currentPane = currentStartingPane;
    while (dx < gameRef.camera.position.x + gameRef.size.x + w - x) {
      int? brokenType = brokenPanes[currentPane];

      Sprite sprite =
          brokenType != null ? Tileset.brokenWalls[brokenType] : wallSprite;
      sprite.render(c, position: Vector2(dx, startY), size: Vector2(w, h));

      dx += w;
      currentPane++;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    if (x + gameRef.size.x < gameRef.player.x - gameRef.size.x) {
      int panesToMove = gameRef.size.x ~/ w;
      x += panesToMove * w;
      currentStartingPane += panesToMove;
    }
    brokenPanes.removeWhere((key, value) => currentStartingPane - 1 > key);
  }

  void spawnBrokenGlass({required bool before, int number = 1}) {
    final startingPane = currentStartingPane + (gameRef.player.x - x) ~/ w;
    final numberOfPanes = before ? 4 : gameRef.size.x ~/ w;
    final sign = before ? -1 : 1;

    Map<int, int> newBrokenPanes = List<int>.generate(numberOfPanes, (e) => e)
        .shuffled()
        .map((e) => startingPane + sign * e)
        .where((e) => !brokenPanes.containsKey(e))
        .take(number)
        .associateBy((_) => Tileset.brokenWalls.randomIdx(R));

    newBrokenPanes.forEach((paneIdx, brokenType) {
      final delta = Tileset.brokenWallDeltas[brokenType];
      double dx = x + (paneIdx - currentStartingPane) * w + delta.key;
      double dy = startY + delta.value;
      gameRef.add(BrokenGlass(dx, dy));
    });

    if (newBrokenPanes.isNotEmpty) {
      gameRef.vibrate();
    }

    brokenPanes.addAll(newBrokenPanes);
  }

  @override
  int get priority => 2;
}
