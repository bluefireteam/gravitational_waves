import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../game.dart';
import 'player.dart';

class Background extends PositionComponent with Resizable, HasGameRef<MyGame> {

  static const int CHUNCK_SIZE = 32;
  static final Paint _paint = Paint()..color = const Color(0xFFFF00FF);

  List<int> top;
  List<int> bottom;

  Background(double x) {
    this.x = x;
    this.top = _generateChunck();
    this.bottom = _generateChunck();
  }

  static List<int> _generateChunck() {
    final r = math.Random();
    return List.generate(CHUNCK_SIZE, (_) => r.nextInt(3));
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
    for (int i = 0; i < CHUNCK_SIZE; i++) {
      double px = x + i * blockWidth;

      double topHeight = blockHeight * (3 + top[i]);
      c.drawRect(Rect.fromLTWH(px, 0.0, blockWidth, topHeight), _paint);

      double bottomHeight = blockHeight * (3 + bottom[i]);
      c.drawRect(Rect.fromLTWH(px, size.height - bottomHeight, blockWidth, bottomHeight), _paint);
    }
  }

  @override
  void update(double t) {}

  @override
  bool destroy() => endX < gameRef.camera.x - size.width;
}