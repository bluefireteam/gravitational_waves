import 'package:flame/flame.dart';
import 'dart:ui';

class UITileset {
  static Image tileset;

  static Future<void> init() async {
    tileset = await Flame.images.load('container-tileset.png');
  }
}
