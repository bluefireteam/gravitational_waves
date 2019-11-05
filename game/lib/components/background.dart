import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import 'player.dart';

class Column {
  int bottom, top;
  Column(this.bottom, this.top);
}

class Background extends PositionComponent with Resizable, HasGameRef<MyGame> {

  static const int CHUNCK_SIZE = 64;
  static final Paint _paint = Paint()..color = const Color(0xFFFF00FF);

  List<Column> columns;

  Background(double x) {
    this.x = x;
    this.columns = _generateChunck().toList();
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

  double get blockWidth => size.width * 2 / CHUNCK_SIZE;
  double get blockHeight => size.height / 14;

  double get startX => x;
  double get endX => x + blockWidth * CHUNCK_SIZE;

  bool contains(Player player) {
    return player.x >= startX && player.x <= endX;
  }

  @override
  void render(Canvas c) {
    columns.asMap().forEach((i, column) {
      double px = x + i * blockWidth;

      double topHeight = blockHeight * (3 + column.top);
      c.drawRect(Rect.fromLTWH(px, 0.0, blockWidth, topHeight), _paint);

      double bottomHeight = blockHeight * (3 + column.bottom);
      c.drawRect(Rect.fromLTWH(px, size.height - bottomHeight, blockWidth, bottomHeight), _paint);
    });
  }

  @override
  void update(double t) {}

  @override
  bool destroy() => endX < gameRef.camera.x - size.width;

  Rect findRectContaining(double targetX) {
    int idx = ((targetX - x) / blockWidth).round();
    double px = x + idx * blockWidth;
    Column column = columns[idx];
    double top = blockHeight * (3 + column.top);
    double bottom = blockHeight * (3 + column.bottom);
    return Rect.fromLTWH(px, top, blockWidth, size.height - top - bottom);
  }
}