// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData()
  ..coins = json['coins'] as int
  ..selectedSkin = $enumDecode(_$SkinEnumMap, json['selectedSkin'])
  ..ownedSkins = (json['ownedSkins'] as List<dynamic>)
      .map((e) => $enumDecode(_$SkinEnumMap, e))
      .toList()
  ..playerId = json['playerId'] as String?
  ..highScore = json['highScore'] as int?;

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'coins': instance.coins,
      'selectedSkin': _$SkinEnumMap[instance.selectedSkin],
      'ownedSkins': instance.ownedSkins.map((e) => _$SkinEnumMap[e]).toList(),
      'playerId': instance.playerId,
      'highScore': instance.highScore,
    };

const _$SkinEnumMap = {
  Skin.ASTRONAUT: 'ASTRONAUT',
  Skin.SECURITY: 'SECURITY',
  Skin.PINK_HAIR_PUNK: 'PINK_HAIR_PUNK',
  Skin.GREEN_HAIR_PUNK: 'GREEN_HAIR_PUNK',
  Skin.ROBOT: 'ROBOT',
  Skin.HAZMAT_SUIT: 'HAZMAT_SUIT',
  Skin.VAMPIRE: 'VAMPIRE',
  Skin.RETRO_PILOT: 'RETRO_PILOT',
  Skin.ALIEN: 'ALIEN',
};
