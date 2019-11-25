// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tileset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimationElement _$AnimationElementFromJson(Map<String, dynamic> json) {
  return AnimationElement()
    ..x = json['x'] as int
    ..y = json['y'] as int
    ..w = json['w'] as int
    ..h = json['h'] as int
    ..length = json['length'] as int
    ..millis = json['millis'] as int;
}

Map<String, dynamic> _$AnimationElementToJson(AnimationElement instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'length': instance.length,
      'millis': instance.millis,
    };

AnimationsJson _$AnimationsJsonFromJson(Map<String, dynamic> json) {
  return AnimationsJson()
    ..animations = (json['animations'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          e == null
              ? null
              : AnimationElement.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$AnimationsJsonToJson(AnimationsJson instance) =>
    <String, dynamic>{
      'animations': instance.animations,
    };
