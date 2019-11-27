import 'package:flame/text_config.dart';

import 'palette.dart';

const BLOCK_SIZE = 16.0;
const CHUNCK_SIZE = 64;

const STARS_SPEED = 5.0;
const PLANET_SPEED = 45.0;
const PLAYER_SPEED = 170.0;
const GRAVITY_ACC = 2750.0;

class Fonts {
  static final TextConfig _base = TextConfig(fontFamily: 'BitPotion');
  static final TextConfig menuTitle = _base.withFontSize(64.0).withColor(Palette.menuTitleText.color);
  static final TextConfig menuItems = _base.withFontSize(28.0).withColor(Palette.menuItemsText.color);
  static final TextConfig gameOverItems = _base.withFontSize(16.0).withColor(Palette.menuItemsText.color);
  static final TextConfig livesCounter = _base.withFontSize(16.0).withColor(Palette.livesCounter.color);
  static final TextConfig scoreCounter = _base.withFontSize(16.0).withColor(Palette.livesCounter.color);
}