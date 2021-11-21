import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'skin.dart';

part 'game_data.g.dart';

@JsonSerializable()
class GameData {
  static late GameData instance;

  int coins;
  Skin selectedSkin;
  List<Skin> ownedSkins;
  String? playerId;
  int? highScore;

  GameData()
      : this.coins = 0,
        this.highScore = null,
        this.selectedSkin = Skin.ASTRONAUT,
        this.ownedSkins = [Skin.ASTRONAUT],
        this.playerId = null;

  Future<bool> buyAndSetSkin(Skin skin) async {
    int price = skinPrice(skin);
    if (this.ownedSkins.contains(skin)) {
      this.selectedSkin = skin;
    } else if (this.coins >= price) {
      this.coins -= price;
      this.ownedSkins.add(skin);
      this.selectedSkin = skin;
    } else {
      return false;
    }

    await this.save();
    return true;
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
    this.highScore = math.max(this.highScore ?? 0, score);
    await this.save();
  }

  Future setPlayerId(String playerId) async {
    this.playerId = playerId;
    await this.save();
  }

  Future<bool> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('gravitational_waves.data', json.encode(toJson()));
  }

  bool isFirstTime() {
    return this.highScore == null;
  }

  static Future<GameData> init() async {
    return instance = await load();
  }

  static Future<GameData> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pref = prefs.getString('gravitational_waves.data');
    if (pref != null) {
      return GameData.fromJson(json.decode(pref));
    } else {
      return GameData();
    }
  }

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);
}
