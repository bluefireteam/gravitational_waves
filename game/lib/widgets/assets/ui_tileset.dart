import 'dart:ui';

import 'package:flame/flame.dart';

class UITileset {
  static late Image tileset;

  static Future<void> init() async {
    tileset = await Flame.images.load('container-tileset.png');
  }
}
