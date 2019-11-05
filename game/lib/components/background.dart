import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import '../util.dart';
import 'player.dart';

class Column {
  int bottom, top;
  Column(this.bottom, this.top);
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
    for (int i = 0; i < CHUNCK_SIZE; i++) {
      if (beforeTop == null || r.nextDouble() < 0.25) {
        beforeTop = r.nextInt(3);
      }
      if (beforeBottom == null || r.nextDouble() < 0.25) {
        beforeBottom = r.nextInt(3);
      }
      yield Column(beforeTop, beforeBottom);
    }
  }

  double get startX => x;
  double get endX => x + BLOCK_SIZE * CHUNCK_SIZE;

  bool contains(Player player) {
    return player.right >= startX && player.right < endX;
  }

  @override
  void render(Canvas c) {
    columns.asMap().forEach((i, column) {
      double px = x + i * BLOCK_SIZE;

      double topHeight = BLOCK_SIZE * (3 + column.top);
      c.drawRect(Rect.fromLTWH(px, 0.0, BLOCK_SIZE, topHeight), _paint);

      double bottomHeight = BLOCK_SIZE * (3 + column.bottom);
      c.drawRect(Rect.fromLTWH(px, size.height - bottomHeight, BLOCK_SIZE, bottomHeight), _paint);
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
    double top = BLOCK_SIZE * (3 + column.top);
    double bottom = BLOCK_SIZE * (3 + column.bottom);
    return Rect.fromLTWH(px, top, BLOCK_SIZE, size.height - top - bottom);
  }
}