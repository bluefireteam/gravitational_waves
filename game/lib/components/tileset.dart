import 'dart:convert';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_annotation/json_annotation.dart';

part 'tileset.g.dart';

@JsonSerializable()
class AnimationElement {
  int x, y, w, h, length, millis;

  AnimationElement();

  factory AnimationElement.fromJson(Map<String, dynamic> json) => _$AnimationElementFromJson(json);
  Map<String, dynamic> toJson() => _$AnimationElementToJson(this);
}

@JsonSerializable()
class AnimationsJson {
  Map<String, AnimationElement> animations;

  AnimationsJson();

  factory AnimationsJson.fromJson(Map<String, dynamic> json) => _$AnimationsJsonFromJson(json);
  Map<String, dynamic> toJson() => _$AnimationsJsonToJson(this);
}

enum TilePosition {
  TOP_LEFT, TOP, TOP_RIGHT,
  LEFT, CENTER, RIGHT,
  BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT
}

class BlockSet {
  static const double SRC_SIZE = 16.0;

  Map<TilePosition, Sprite> blocks;

  BlockSet(AnimationsJson animations, int group) {
    blocks = {
      TilePosition.TOP_LEFT: _blockGn(animations, group, 0, 0),
      TilePosition.TOP: _blockGn(animations, group, 1, 0),
      TilePosition.TOP_RIGHT: _blockGn(animations, group, 2, 0),
      TilePosition.LEFT: _blockGn(animations, group, 0, 1),
      TilePosition.CENTER: _blockGn(animations, group, 1, 1),
      TilePosition.RIGHT: _blockGn(animations, group, 2, 1),
      TilePosition.BOTTOM_LEFT: _blockGn(animations, group, 0, 2),
      TilePosition.BOTTOM: _blockGn(animations, group, 1, 2),
      TilePosition.BOTTOM_RIGHT: _blockGn(animations, group, 2, 2),
    };
  }

  void render(Canvas c, TilePosition pos, double dx, double dy) {
    blocks[pos].renderPosition(c, Position(dx, dy));
  }

  static Sprite _blockGn(AnimationsJson animations, int group, int dx, int dy) {
    AnimationElement animation = animations.animations['back-group-$group'];
    double x = (animation.x + dx) * SRC_SIZE;
    double y = (animation.y + dy) * SRC_SIZE;
    print('x $x, y $y');
    return Sprite('tileset.png', x: x, y: y, width: SRC_SIZE, height: SRC_SIZE);
  }
}

class Tileset {
  static AnimationsJson animations;
  static BlockSet g1, g2;

  static Future init() async {
    String content = await rootBundle.loadString('assets/images/tileset.json');
    animations = AnimationsJson.fromJson(json.decode(content));
    g1 = BlockSet(animations, 1);
    g2 = BlockSet(animations, 2);
  }

  static BlockSet group(int group) {
    return group == 1 ? g1 : g2;
  }
}