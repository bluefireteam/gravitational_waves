import 'package:json_annotation/json_annotation.dart';

part 'tileset.g.dart';

@JsonSerializable()
class AnimationElement {
  int x, y, w, h, length, millis;
}