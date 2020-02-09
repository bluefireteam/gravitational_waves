import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../assets/tileset.dart';
import '../collections.dart';
import '../column.dart';
import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'tutorial.dart';

class Background extends PositionComponent with HasGameRef<MyGame>, Resizable {
  static final Paint _bg = Palette.background.paint;

  List<Column> columns;

  Background(double x) {
    this.x = x;
    this.columns = _generateChunck(CHUNCK_SIZE).toList();
  }

  Background.plains(double x) {
    this.x = x;
    this.columns = _generatePlains(CHUNCK_SIZE).toList();
  }

  Background.tutorial(double x) {
    this.x = x;
    this.columns = Tutorial.generateTerrain().toList();
  }

  static Iterable<Column> _generatePlains(int size) {
    return List.generate(size, (_) => Column(0, 0));
  }

  static Iterable<Column> _generateChunck(int size) sync* {
    int beforeTop, beforeBottom;
    int changesTop = 0, changesBottom = 0;
    for (int i = 0; i < size; i++) {
      if (i < 3 || i >= size - 3) {
        yield Column(0, 0);
      } else {
        bool nextForcedZero = (i + 1) >= size - 3;
        if (beforeTop == null || (changesTop / 2 * R.nextDouble() > 0.9)) {
          beforeTop = nextForcedZero ? 0 : R.nextInt(3);
          changesTop = 0;
        } else {
          changesTop++;
        }
        if (beforeBottom == null ||
            (changesBottom / 2 * R.nextDouble() > 0.9)) {
          beforeBottom = nextForcedZero ? 0 : R.nextInt(3);
          changesBottom = 0;
        } else {
          changesBottom++;
        }
        yield Column(beforeTop, beforeBottom);
      }
    }
  }

  double get startX => x;
  double get endX => x + BLOCK_SIZE * columns.length;

  bool contains(double targetX) {
    return targetX >= startX && targetX < endX;
  }

  @override
  void render(Canvas c) {
    columns.asMap().forEach((i, column) {
      Column before = columns.getOrElse(i - 1, column);
      Column after = columns.getOrElse(i + 1, column);
      double px = x + i * BLOCK_SIZE;

      c.drawRect(Rect.fromLTWH(px, 0.0, BLOCK_SIZE, column.topHeight), _bg);
      c.drawRect(
          Rect.fromLTWH(px, size.height - column.bottomHeight, BLOCK_SIZE,
              column.bottomHeight),
          _bg);

      double bottomPy = size.height - column.bottomHeight;
      BlockSet bottomSet = Tileset.variant(column.bottomVariant);
      if (before.bottom < column.bottom) {
        int diff = column.bottom - before.bottom;
        bottomSet.renderOuter(c, OuterTilePosition.TOP_LEFT, px, bottomPy);
        for (int i = 1; i < diff; i++) {
          bottomSet.renderOuter(
              c, OuterTilePosition.LEFT, px, bottomPy + i * BLOCK_SIZE);
        }
        bottomSet.renderInner(c, InnerTilePosition.BOTTOM_RIGHT, px,
            bottomPy + diff * BLOCK_SIZE);
      } else if (after.bottom < column.bottom) {
        int diff = column.bottom - after.bottom;
        bottomSet.renderOuter(c, OuterTilePosition.TOP_RIGHT, px, bottomPy);
        for (int i = 1; i < diff; i++) {
          bottomSet.renderOuter(
              c, OuterTilePosition.RIGHT, px, bottomPy + i * BLOCK_SIZE);
        }
        bottomSet.renderInner(
            c, InnerTilePosition.BOTTOM_LEFT, px, bottomPy + diff * BLOCK_SIZE);
      } else {
        bottomSet.renderOuter(c, OuterTilePosition.TOP, px, bottomPy);
      }

      double topPy = column.topHeight - BLOCK_SIZE;
      BlockSet topSet = Tileset.variant(column.topVariant);
      if (before.top < column.top) {
        int diff = column.top - before.top;
        topSet.renderOuter(c, OuterTilePosition.BOTTOM_LEFT, px, topPy);
        for (int i = 1; i < diff; i++) {
          topSet.renderOuter(
              c, OuterTilePosition.LEFT, px, topPy - i * BLOCK_SIZE);
        }
        topSet.renderInner(
            c, InnerTilePosition.TOP_RIGHT, px, topPy - diff * BLOCK_SIZE);
      } else if (after.top < column.top) {
        int diff = column.top - after.top;
        topSet.renderOuter(c, OuterTilePosition.BOTTOM_RIGHT, px, topPy);
        for (int i = 1; i < diff; i++) {
          topSet.renderOuter(
              c, OuterTilePosition.RIGHT, px, topPy - i * BLOCK_SIZE);
        }
        topSet.renderInner(
            c, InnerTilePosition.TOP_LEFT, px, topPy - diff * BLOCK_SIZE);
      } else {
        topSet.renderOuter(c, OuterTilePosition.BOTTOM, px, topPy);
      }
    });
    if (DEBUG) {
      renderDebug(c);
    }
  }

  void renderDebug(Canvas c) {
    c.drawRect(
      Rect.fromLTWH(startX, 0.0, endX - startX, size.height),
      Paint()
        ..color = Color(0xFFFF00FF)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  void update(double t) {}

  @override
  bool destroy() => endX < gameRef.camera.x - size.width;

  @override
  int priority() => 3;

  Rect findRectContaining(double targetX) {
    int idx = ((targetX - x) / BLOCK_SIZE).floor();
    return findRectFor(idx);
  }

  Rect findRectFor(int idx) {
    Column column = columns[idx];
    double px = x + idx * BLOCK_SIZE;
    return Rect.fromLTWH(px, column.topHeight, BLOCK_SIZE,
        size.height - column.topHeight - column.bottomHeight);
  }
}
