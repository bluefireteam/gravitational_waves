import 'dart:ui';

import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

/// This allows you to create a rectangle textured with a 9-sliced image.
/// 
/// How it works is that you have a template image in a 3x3 grid, made up of 9 tiles,
/// and a new rectangle can be draw by keeping the 4 corners, expanding the 4 sides only
/// in the direction in which they are located and expanding the center in both directions.
/// That allows you to have non distored borders.
class NineBox {

  /// The sprite used to render the box, must be a 3x3 grid of square tiles.
  Sprite sprite;

  /// The size of each tile in the source sprite image.
  int tileSize;

  /// Creates a nine-box instance.
  /// 
  /// [srite] is the 3x3 grid and [tileSize] is the size of each tile.
  /// The src sprite must a square of size 3*[tileSize].
  /// 
  /// If [tileSize is not provided, the width of the sprite is assumed as the size.
  /// Otherwise the width and height properties of the sprite are ignored.
  NineBox(this.sprite, { int tileSize }) {
    this.tileSize = tileSize ?? this.sprite.src.width.toInt();
  }

  /// Renders this nine box as a rectangle of coordinates ([x], [y]) and size ([width], [height]).
  /// 
  /// Since the corners are kept, the width and height must be at least 2*tileSize.
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
    double xSrc = sprite.src.left + _tileSizeDouble * i;
    double ySrc = sprite.src.top + _tileSizeDouble * j;
    Rect src = Rect.fromLTWH(xSrc, ySrc, _tileSizeDouble, _tileSizeDouble);
    c.drawImageRect(sprite.image, src, dest, BasicPalette.white.paint);
  }
}