import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';

class Background extends PositionComponent with Resizable {

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
  double get blockHeight => size.width / 18;

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
}