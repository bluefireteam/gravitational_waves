// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences()
  ..musicOn = json['musicOn'] as bool
  ..soundOn = json['soundOn'] as bool
  ..rumbleOn = json['rumbleOn'] as bool
  ..language = json['language'] as String;

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'musicOn': instance.musicOn,
      'soundOn': instance.soundOn,
      'rumbleOn': instance.rumbleOn,
      'language': instance.language,
    };
