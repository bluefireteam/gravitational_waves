// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spritesheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimationElement _$AnimationElementFromJson(Map<String, dynamic> json) =>
    AnimationElement(
      json['x'] as int,
      json['y'] as int,
      json['w'] as int,
      json['h'] as int,
      json['length'] as int,
      json['millis'] as int,
    );

Map<String, dynamic> _$AnimationElementToJson(AnimationElement instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'length': instance.length,
      'millis': instance.millis,
    };

AnimationsJson _$AnimationsJsonFromJson(Map<String, dynamic> json) =>
    AnimationsJson(
      (json['animations'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, AnimationElement.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AnimationsJsonToJson(AnimationsJson instance) =>
    <String, dynamic>{
      'animations': instance.animations,
    };
