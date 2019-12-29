import 'dart:async';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'game_data.g.dart';

@JsonSerializable()
class GameData {

  static GameData instance;

  int coins;

  GameData() {
    this.coins = 0;
  }

  Future addCoins(int coins) async {
    this.coins += coins;
    await this.save();
  }

  Future<bool> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('gravitational_waves.data', json.encode(toJson()));
  }

  static Future<GameData> init() async {
    return instance ??= await load();
  }

  static Future<GameData> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pref = prefs.getString('gravitational_waves.data');
    if (pref != null) {
      return GameData.fromJson(json.decode(pref));
    } else {
      return GameData();
    }
  }

  factory GameData.fromJson(Map<String, dynamic> json) => _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);
}