import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import '../util.dart';

class Column {
  static const OFFSET = 5;

  int bottom, top;
  Column(this.bottom, this.top);

  double get topHeight => BLOCK_SIZE * (OFFSET + top);
  double get bottomHeight => BLOCK_SIZE * (OFFSET + bottom);
}

class Background extends PositionComponent with HasGameRef<MyGame>, Resizable {

  static final Paint _paint = Paint()..color = const Color(0xFFFF00FF);

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
      double px = x + i * BLOCK_SIZE;

      c.drawRect(Rect.fromLTWH(px, 0.0, BLOCK_SIZE, column.topHeight), _paint);
      c.drawRect(Rect.fromLTWH(px, size.height - column.bottomHeight, BLOCK_SIZE, column.bottomHeight), _paint);
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
}