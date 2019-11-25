import 'dart:convert';
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
  static AnimationsJson animations;

  static init() async {
    String content = await rootBundle.loadString('assets/animations.json');
    animations = AnimationsJson.fromJson(json.decode(content));
  }
}