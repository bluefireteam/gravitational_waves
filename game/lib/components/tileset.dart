import 'dart:convert';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_annotation/json_annotation.dart';

import '../util.dart';

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

  List<T> generate<T>(String name, T Function(String) generator) {
    List<T> list = [];
    int i = 1;
    while (true) {
      String key = '$name-$i';
      if (!animations.containsKey(key)) {
        break;
      }
      list.add(generator(key));
      i++;
    }
    return list;
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
  static List<BlockSet> blocks;
  static Sprite wall;
  static List<Sprite> planets;
  static List<Sprite> stars;

  static Future init() async {
    String content = await rootBundle.loadString('assets/images/tileset.json');
    AnimationsJson animations = AnimationsJson.fromJson(json.decode(content));

    wall = animations.sprite('wall-pattern');
    blocks = [1, 2].map((i) => BlockSet(animations, i)).toList();
    planets = animations.generate('back-props', (key) => animations.sprite(key));
    stars = animations.generate('stars-pattern', (key) => animations.sprite(key));
  }

  static BlockSet variant(int variant) {
    return blocks[variant];
  }

  static int randomVariant() {
    return R.nextInt(blocks.length);
  }
}