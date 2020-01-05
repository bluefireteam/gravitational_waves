import 'package:flutter/widgets.dart' as Widgets;
import 'package:flame/sprite.dart';
import 'dart:ui';

class _Painter extends Widgets.CustomPainter {

  final  spriteSheet;
  final double tileSize;
  final double destTileSize;

  _Painter({ this.spriteSheet, this.tileSize, this.destTileSize });

  @override
  void paint(Canvas canvas, Size size) {
    final topLeftCorner = Sprite.fromImage(spriteSheet, x: 0, y: 0, width: tileSize, height: tileSize);
    final topRightCorner = Sprite.fromImage(spriteSheet, x: tileSize * 2, y: 0, width: tileSize, height: tileSize);

    final bottomLeftCorner = Sprite.fromImage(spriteSheet, x: 0, y: 2 * tileSize, width: tileSize, height: tileSize);
    final bottomRightCorner = Sprite.fromImage(spriteSheet, x: tileSize * 2, y: 2 * tileSize, width: tileSize, height: tileSize);

    final topSide = Sprite.fromImage(spriteSheet, x: tileSize, y: 0, width: tileSize, height: tileSize);
    final bottomSide = Sprite.fromImage(spriteSheet, x: tileSize, y: tileSize * 2, width: tileSize, height: tileSize);

    final leftSide = Sprite.fromImage(spriteSheet, x: 0, y: tileSize, width: tileSize, height: tileSize);
    final rightSide = Sprite.fromImage(spriteSheet, x: tileSize * 2, y: tileSize, width: tileSize, height: tileSize);

    final middle = Sprite.fromImage(spriteSheet, x: tileSize, y: tileSize, width: tileSize, height: tileSize);

    // Middle
    for (var y = destTileSize; y < size.height - destTileSize; y = y + destTileSize) {
      for (var x = destTileSize; x < size.width - destTileSize; x = x + destTileSize) {
        middle.renderRect(canvas, Rect.fromLTWH(x, y, destTileSize, destTileSize));
      }
    }

    // Top and bottom side
    for (var i = destTileSize; i < size.width - destTileSize; i = i + destTileSize) {
      topSide.renderRect(canvas, Rect.fromLTWH(i, 0, destTileSize, destTileSize));
      bottomSide.renderRect(canvas, Rect.fromLTWH(i, size.height - destTileSize, destTileSize, destTileSize));
    }

    // Left and right side
    for (var i = destTileSize; i < size.height - destTileSize; i = i + destTileSize) {
      leftSide.renderRect(canvas, Rect.fromLTWH(0, i, destTileSize, destTileSize));
      rightSide.renderRect(canvas, Rect.fromLTWH(size.width - destTileSize, i, destTileSize, destTileSize));
    }

    // Corners
    topLeftCorner.renderRect(canvas, Rect.fromLTWH(0, 0, destTileSize, destTileSize));
    topRightCorner.renderRect(canvas, Rect.fromLTWH(size.width - destTileSize, 0, destTileSize, destTileSize));

    bottomLeftCorner.renderRect(canvas, Rect.fromLTWH(0, size.height - destTileSize, destTileSize, destTileSize));
    bottomRightCorner.renderRect(canvas, Rect.fromLTWH(size.width - destTileSize, size.height - destTileSize, destTileSize, destTileSize));

  }

   @override
  bool shouldRepaint(_) => false;
}

class SpritesheetContainer extends Widgets.StatelessWidget {
  final Image spriteSheet;
  final double tileSize;
  final double destTileSize;
  final double width;
  final double height;

  final Widgets.Widget child;

  final Widgets.EdgeInsetsGeometry padding;

  SpritesheetContainer({
    this.spriteSheet,
    this.tileSize,
    this.destTileSize,
    this.child,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widgets.Widget build(Widgets.BuildContext context) {
    return Widgets.Container(
        width: width,
        height: height,
        child: Widgets.CustomPaint(
            painter: _Painter(
                spriteSheet: spriteSheet,
                tileSize: tileSize,
                destTileSize: destTileSize
            ),
            child: Widgets.Container(
                child: child,
                padding: padding,
            )
        )
    );
  }
}
