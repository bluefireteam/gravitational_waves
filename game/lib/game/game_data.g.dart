// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) {
  return GameData()
    ..coins = json['coins'] as int
    ..selectedSkin = _$enumDecodeNullable(_$SkinEnumMap, json['selectedSkin'])
    ..playerId = json['playerId'] as String
    ..highScore = json['highScore'] as int;
}

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'coins': instance.coins,
      'selectedSkin': _$SkinEnumMap[instance.selectedSkin],
      'playerId': instance.playerId,
      'highScore': instance.highScore,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SkinEnumMap = {
  Skin.ASTRONAUT: 'ASTRONAUT',
  Skin.SECURITY: 'SECURITY',
};
