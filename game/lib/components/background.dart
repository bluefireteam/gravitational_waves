import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'tileset.dart';

class Column {
  static const OFFSET = 5;

  int bottom, top;
  int bottomRandom, topRandom;

  Column(this.bottom, this.top, { this.bottomRandom = 1, this.topRandom = 1 });

  double get topHeight => BLOCK_SIZE * (OFFSET + top);
  double get bottomHeight => BLOCK_SIZE * (OFFSET + bottom);
}

class Background extends PositionComponent with HasGameRef<MyGame>, Resizable {

  static final Paint _paint = Palette.background.paint;

  List<Column> columns;

  Background(double x) {
    this.x = x;
    this.columns = _generateChunck().toList();
  }

  Background.plains(double x) {
    this.x = x;
    this.columns = List.generate(CHUNCK_SIZE, (_) => Column(0, 0));
  }

  static Iterable<Column> _generateChunck() sync* {
    final r = math.Random();
    int beforeTop, beforeBottom;
    int changesTop = 0, changesBottom = 0;
    for (int i = 0; i < CHUNCK_SIZE; i++) {
      if (beforeTop == null || (changesTop * r.nextDouble() > 0.85)) {
        beforeTop = r.nextInt(3);
        changesTop = 0;
      } else {
        changesTop++;
      }
      if (beforeBottom == null || (changesBottom * r.nextDouble() > 0.85)) {
        beforeBottom = r.nextInt(3);
        changesBottom = 0;
      } else {
        changesBottom++;
      }
      int bottomRandom = r.nextDouble() > 0.5 ? 1 : 2;
      int topRandom = r.nextDouble() > 0.5 ? 1 : 2;
      yield Column(beforeTop, beforeBottom, bottomRandom: bottomRandom, topRandom: topRandom);
    }
  }

  double get startX => x;
  double get endX => x + BLOCK_SIZE * CHUNCK_SIZE;

  bool contains(double targetX) {
    return targetX >= startX && targetX < endX;
  }

  @override
  void render(Canvas c) {
    columns.asMap().forEach((i, column) {
      Column before = getOrElse(columns, i - 1, column);
      Column after = getOrElse(columns, i + 1, column);

      double px = x + i * BLOCK_SIZE;

      c.drawRect(Rect.fromLTWH(px, 0.0, BLOCK_SIZE, column.topHeight), _paint);
      c.drawRect(Rect.fromLTWH(px, size.height - column.bottomHeight, BLOCK_SIZE, column.bottomHeight), _paint);

      double bottomPy = size.height - column.bottomHeight;
      BlockSet bottomSet = Tileset.group(column.bottomRandom);
      if (before.bottom < column.bottom) {
        bottomSet.render(c, OuterTilePosition.TOP_LEFT, px, bottomPy);
        int diff = column.bottom - before.bottom;
        for (int i = 1; i <= diff; i++) {
          OuterTilePosition pos = i == diff ? OuterTilePosition.BOTTOM_LEFT : OuterTilePosition.LEFT;
          bottomSet.render(c, pos, px, bottomPy + i * BLOCK_SIZE);
        }
      } else if (after.bottom < column.bottom) {
        bottomSet.render(c, OuterTilePosition.TOP_RIGHT, px, bottomPy);
        int diff = column.bottom - after.bottom;
        for (int i = 1; i <= diff; i++) {
          OuterTilePosition pos = i == diff ? OuterTilePosition.BOTTOM_RIGHT : OuterTilePosition.RIGHT;
          bottomSet.render(c, pos, px, bottomPy + i * BLOCK_SIZE);
        }
      } else {
        bottomSet.render(c, OuterTilePosition.TOP, px, bottomPy);
      }

      double topPy = column.topHeight - BLOCK_SIZE;
      BlockSet topSet = Tileset.group(column.topRandom);
      if (before.top < column.top) {
        topSet.render(c, OuterTilePosition.BOTTOM_LEFT, px, topPy);
        int diff = column.top - before.top;
        for (int i = 1; i <= diff; i++) {
          OuterTilePosition pos = i == diff ? OuterTilePosition.TOP_RIGHT : OuterTilePosition.LEFT;
          topSet.render(c, pos, px, topPy - i * BLOCK_SIZE);
        }
      } else if (after.top < column.top) {
        topSet.render(c, OuterTilePosition.BOTTOM_RIGHT, px, topPy);
        int diff = column.top - after.top;
        for (int i = 1; i <= diff; i++) {
          OuterTilePosition pos = i == diff ? OuterTilePosition.TOP_LEFT : OuterTilePosition.RIGHT;
          topSet.render(c, pos, px, topPy - i * BLOCK_SIZE);
        }
      } else {
        topSet.render(c, OuterTilePosition.BOTTOM, px, topPy);
      }
    });
  }

  @override
  void update(double t) {}

  @override
  bool destroy() => endX < gameRef.camera.x - size.width;

  Rect findRectContaining(double targetX) {
    int idx = ((targetX - x) / BLOCK_SIZE).floor();
    Column column = columns[idx];

    double px = x + idx * BLOCK_SIZE;
    return Rect.fromLTWH(px, column.topHeight, BLOCK_SIZE, size.height - column.topHeight - column.bottomHeight);
  }

  static T getOrElse<T>(List<T> ts, int idx, T elseValue) {
    if (idx >= 0 && idx < ts.length - 1) {
      return ts[idx];
    }
    return elseValue;
  }
}