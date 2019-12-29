import 'dart:async';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {

  static Preferences instance;

  bool musicOn;
  bool soundOn;
  bool rumbleOn;
  String language;

  Preferences() {
    this.musicOn = true;
    this.soundOn = true;
    this.rumbleOn = true;
    this.language = 'en_US';
  }

  Future toggleMusic() async {
    this.musicOn = !this.musicOn;
    if (!this.musicOn) {
      Audio.stopMusic();
    }
    await this.save();
  }

  Future toggleSounds() async {
    this.soundOn = !this.soundOn;
    await this.save();
  }

  Future toggleRumble() async {
    this.rumbleOn = !this.rumbleOn;
    await this.save();
  }

  Future<bool> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('gravitational_waves.prefs', json.encode(toJson()));
  }

  static Future<Preferences> init() async {
    return instance ??= await load();
  }

  static Future<Preferences> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pref = prefs.getString('gravitational_waves.prefs');
    if (pref != null) {
      return Preferences.fromJson(json.decode(pref));
    } else {
      return Preferences();
    }
  }

  factory Preferences.fromJson(Map<String, dynamic> json) => _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}