import 'package:flame/animation.dart';

import 'spritesheet.dart';

class Poofs {
  static Spritesheet _sheet;

  static Animation poof() => _animation('poof')..loop = false;
  static Animation airEscaping() => _animation('air_escaping');
  static Animation glassBreaking() =>
      _animation('glass_breaking')..loop = false;

  static Future init() async {
    _sheet = await Spritesheet.parse('poofs');
  }

  static Animation _animation(String name) {
    return _sheet.animations.animations[name].animation('poofs');
  }
}
