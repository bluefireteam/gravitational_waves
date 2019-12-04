import 'package:flame/sprite.dart';

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
}