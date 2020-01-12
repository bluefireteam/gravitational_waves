import 'package:flame/sprite.dart';

import '../skin.dart';
import './spritesheet.dart';

class Char {
  static Spritesheet _sheet;

  static Sprite astronaut = _skin('astronaut');
  static Sprite security = _skin('security');
  static Sprite pinkHairPunk = _skin('punk');
  static Sprite greenHairPunk = _skin('punk-2');
  static Sprite robot = _skin('robot');
  static Sprite hazmatSuit = _skin('hazmat-suit');

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
      case Skin.PINK_HAIR_PUNK:
        return pinkHairPunk;
      case Skin.GREEN_HAIR_PUNK:
        return greenHairPunk;
      case Skin.ROBOT:
        return robot;
      case Skin.HAZMAT_SUIT:
        return hazmatSuit;
    }
    throw 'Unknown skin! $skin';
  }
}
