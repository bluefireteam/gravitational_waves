import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

import '../collections.dart';
import '../util.dart';
import 'spritesheet.dart';

enum OuterTilePosition {
  TOP_LEFT,
  TOP,
  TOP_RIGHT,
  LEFT,
  CENTER,
  RIGHT,
  BOTTOM_LEFT,
  BOTTOM,
  BOTTOM_RIGHT
}

enum InnerTilePosition {
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
}

class BlockSet {
  Map<OuterTilePosition, Sprite> _outer;
  Map<InnerTilePosition, Sprite> _inner;

  BlockSet(Spritesheet sheet, int group) {
    final outerGn = (dx, dy) => sheet.blockGn('back-group-$group', dx, dy);
    final innerGn = (dx, dy) => sheet.blockGn('corners-$group', dx, dy);
    _outer = {
      OuterTilePosition.TOP_LEFT: outerGn(0, 0),
      OuterTilePosition.TOP: outerGn(1, 0),
      OuterTilePosition.TOP_RIGHT: outerGn(2, 0),
      OuterTilePosition.LEFT: outerGn(0, 1),
      OuterTilePosition.CENTER: outerGn(1, 1),
      OuterTilePosition.RIGHT: outerGn(2, 1),
      OuterTilePosition.BOTTOM_LEFT: outerGn(0, 2),
      OuterTilePosition.BOTTOM: outerGn(1, 2),
      OuterTilePosition.BOTTOM_RIGHT: outerGn(2, 2),
    };
    _inner = {
      InnerTilePosition.TOP_LEFT: innerGn(0, 0),
      InnerTilePosition.TOP_RIGHT: innerGn(1, 0),
      InnerTilePosition.BOTTOM_LEFT: innerGn(0, 1),
      InnerTilePosition.BOTTOM_RIGHT: innerGn(1, 1),
    };
  }

  void renderOuter(Canvas c, OuterTilePosition pos, double dx, double dy) {
    _outer[pos].renderPosition(c, Position(dx, dy));
  }

  void renderInner(Canvas c, InnerTilePosition pos, double dx, double dy) {
    _inner[pos].renderPosition(c, Position(dx, dy));
  }
}

class Tileset {
  static Spritesheet _sheet;

  static List<BlockSet> blocks;

  static Sprite wall;
  static List<Sprite> brokenWalls;
  static List<Pair<int, int>> brokenWallDeltas;

  static List<Sprite> planets;
  static List<Sprite> stars;

  static Future init() async {
    _sheet = await Spritesheet.parse('tileset');

    wall = _sheet.sprite('wall-pattern');
    brokenWalls = _sheet.generate('broken-wall-pattern');
    brokenWallDeltas = [
      Pair(3 * BLOCK_SIZE_INT, 2 * BLOCK_SIZE_INT),
      Pair(1 * BLOCK_SIZE_INT, 3 * BLOCK_SIZE_INT),
    ];

    blocks = [1, 2].map((i) => BlockSet(_sheet, i)).toList();
    planets = _sheet.generate('back-props');
    stars = _sheet.generate('stars-pattern');
  }

  static BlockSet variant(int variant) {
    return blocks[variant];
  }

  static int randomVariant() {
    return blocks.randomIdx(R);
  }

  Sprite sprite(String name) {
    return _sheet.sprite(name);
  }
}
