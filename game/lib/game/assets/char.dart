import 'package:flame/sprite.dart';

import '../skin.dart';
import './spritesheet.dart';

class Char {
  static Spritesheet _sheet;

  static Sprite astronaut = _skin('astronaut');
  static Sprite security = _skin('security');

  static Future init() async {
    _sheet = await Spritesheet.parse('char');
  }

  static Sprite _skin(String name) {
    return _sheet.sprite(name);
  }

  static Sprite fromSkin(Skin skin) {
    switch (skin) {
      case Skin.ASTRONAUT:
        return astronaut;
      case Skin.SECURITY:
        return security;
    }
    throw 'Unknown skin! $skin';
  }
}
