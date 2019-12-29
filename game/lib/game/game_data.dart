import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'skin.dart';

part 'game_data.g.dart';

@JsonSerializable()
class GameData {

  static GameData instance;

  int coins;
  Skin selectedSkin;
  String playerId;
  int highScore;

  GameData() {
    this.coins = 0;
    this.highScore = null;
    this.selectedSkin = Skin.ASTRONAUT;
    this.playerId = 'luanpotter'; // TODO allow this to change
  }

  Future addCoins(int coins) async {
    this.coins += coins;
    await this.save();
  }

  Future changeSkin(Skin skin) async {
    this.selectedSkin = skin;
    await this.save();
  }

  Future addScore(int score) async {
    this.highScore = math.max(this.highScore, score);
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