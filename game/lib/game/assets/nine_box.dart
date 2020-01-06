import 'dart:ui';

import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

class NineBox {
  Sprite sprite;
  int tileSize;

  NineBox(this.sprite, this.tileSize);

  void draw(Canvas c, double x, double y, double width, double height) {
    if (!sprite.loaded()) {
      return;
    }

    assert(width > 2 * tileSize);
    assert(height > 2 * tileSize);

    // corners
    _drawTile(c, _getDest(x, y), 0, 0);
    _drawTile(c, _getDest(x, y + height - tileSize), 0, 2);
    _drawTile(c, _getDest(x + width - tileSize, y), 2, 0);
    _drawTile(c, _getDest(x + width - tileSize, y + height - tileSize), 2, 2);

    // horizontal sides
    double mx = width - 2 * tileSize;
    _drawTile(c, _getDest(x + tileSize, y, width: mx), 1, 0);
    _drawTile(c, _getDest(x + tileSize, y + height - tileSize, width: mx), 1, 2);

    // vertical sides
    double my = height - 2 * tileSize;
    _drawTile(c, _getDest(x, y + tileSize, height: my), 0, 1);
    _drawTile(c, _getDest(x + width - tileSize, y + tileSize, height: my), 2, 1);

    // center
    _drawTile(c, _getDest(x + tileSize, y + tileSize, width: mx, height: my), 1, 1);
  }

  Rect _getDest(double x, double y, { double width, double height }) {
    double w = width ?? _tileSizeDouble;
    double h = height ?? _tileSizeDouble;
    return Rect.fromLTWH(x, y, w, h);
  }

  double get _tileSizeDouble => tileSize.toDouble();

  void _drawTile(Canvas c, Rect dest, int i, int j) {
    double xSrc = _tileSizeDouble * i;
    double ySrc = _tileSizeDouble * j;
    Rect src = Rect.fromLTWH(xSrc, ySrc, _tileSizeDouble, _tileSizeDouble);
    c.drawImageRect(sprite.image, src, dest, BasicPalette.white.paint);
  }
}