import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import '../game.dart';
import '../palette.dart';
import '../util.dart';
import 'tileset.dart';

class Column {
  static const OFFSET = 5;

  int bottom, top;
  Column(this.bottom, this.top);

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
      yield Column(beforeTop, beforeBottom);
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

      Sprite spriteTop;
      if (before.top != column.top) {
        spriteTop = Tileset.blocksG1[2];
      } else if (after.top != column.top) {
        spriteTop = Tileset.blocksG1[8];
      } else {
        spriteTop = Tileset.blocksG1[5];
      }
      spriteTop.renderPosition(c, Position(px, column.topHeight - BLOCK_SIZE));

      Sprite spriteBottom;
      if (before.bottom != column.bottom) {
        spriteBottom = Tileset.blocksG1[0];
      } else if (after.bottom != column.bottom) {
        spriteBottom = Tileset.blocksG1[6];
      } else {
        spriteBottom = Tileset.blocksG1[3];
      }
      spriteBottom.renderPosition(c, Position(px, size.height - column.bottomHeight));
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