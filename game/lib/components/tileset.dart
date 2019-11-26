import 'dart:convert';

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

class Tileset {
  static const double SIZE = 16.0;
  static AnimationsJson animations;
  static List<Sprite> blocksG1;

  static Future init() async {
    String content = await rootBundle.loadString('assets/images/tileset.json');
    animations = AnimationsJson.fromJson(json.decode(content));
    blocksG1 = [
      _blockGn(1, 0, 0),
      _blockGn(1, 0, 1),
      _blockGn(1, 0, 2),
      _blockGn(1, 1, 0),
      _blockGn(1, 1, 1),
      _blockGn(1, 1, 2),
      _blockGn(1, 2, 0),
      _blockGn(1, 2, 1),
      _blockGn(1, 2, 2),
    ];
  }

  static Sprite _blockGn(int group, int dx, int dy) {
    AnimationElement animation = animations.animations['back-group-$group'];
    double x = (animation.x + dx) * SIZE;
    double y = (animation.y + dy) * SIZE;
    print('x $x, y $y');
    return Sprite('tileset.png', x: x, y: y, width: SIZE, height: SIZE);
  }
}