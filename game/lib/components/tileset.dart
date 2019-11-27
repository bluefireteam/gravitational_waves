import 'dart:convert';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_annotation/json_annotation.dart';

part 'tileset.g.dart';

const double _SRC_SIZE = 16.0;

@JsonSerializable()
class AnimationElement {
  int x, y, w, h, length, millis;

  AnimationElement();

  factory AnimationElement.fromJson(Map<String, dynamic> json) => _$AnimationElementFromJson(json);
  Map<String, dynamic> toJson() => _$AnimationElementToJson(this);

  Sprite sprite() {
    double x = this.x * _SRC_SIZE;
    double y = this.y * _SRC_SIZE;
    double w = this.w * _SRC_SIZE;
    double h = this.h * _SRC_SIZE;
    return Sprite('tileset.png', x: x, y: y, width: w, height: h);
  }
}

@JsonSerializable()
class AnimationsJson {
  Map<String, AnimationElement> animations;

  AnimationsJson();

  factory AnimationsJson.fromJson(Map<String, dynamic> json) => _$AnimationsJsonFromJson(json);
  Map<String, dynamic> toJson() => _$AnimationsJsonToJson(this);

  Sprite outerBlockGn(int group, int dx, int dy) {
    return _blockGn('back-group-$group', dx, dy);
  }

  Sprite innerBlockGn(int group, int dx, int dy) {
    return _blockGn('corners-$group', dx, dy);
  }

  Sprite sprite(String name) {
    return animations[name].sprite();
  }

  Sprite _blockGn(String name, int dx, int dy) {
    AnimationElement animation = animations[name];
    double x = (animation.x + dx) * _SRC_SIZE;
    double y = (animation.y + dy) * _SRC_SIZE;
    return Sprite('tileset.png', x: x, y: y, width: _SRC_SIZE, height: _SRC_SIZE);
  }
}

enum OuterTilePosition {
  TOP_LEFT, TOP, TOP_RIGHT,
  LEFT, CENTER, RIGHT,
  BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT
}

enum InnerTilePosition {
  TOP_LEFT, TOP_RIGHT,
  BOTTOM_LEFT, BOTTOM_RIGHT,
}

class BlockSet {

  Map<OuterTilePosition, Sprite> _outer;
  Map<InnerTilePosition, Sprite> _inner;

  BlockSet(AnimationsJson animations, int group) {
    final outerGn = (dx, dy) => animations.outerBlockGn(group, dx, dy);
    final innerGn = (dx, dy) => animations.innerBlockGn(group, dx, dy);
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
  static BlockSet _g1, _g2;
  static Sprite wall;

  static Future init() async {
    String content = await rootBundle.loadString('assets/images/tileset.json');
    AnimationsJson animations = AnimationsJson.fromJson(json.decode(content));
    _g1 = BlockSet(animations, 1);
    _g2 = BlockSet(animations, 2);
    wall = animations.sprite('wall-pattern');
  }

  static BlockSet group(int group) {
    return group == 1 ? _g1 : _g2;
  }
}