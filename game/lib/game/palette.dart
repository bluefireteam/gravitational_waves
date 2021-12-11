import 'package:flame/palette.dart';

class Palette extends BasicPalette {
  static const PaletteEntry black = BasicPalette.black;
  static const PaletteEntry white = BasicPalette.white;

  static const PaletteEntry menuBg = BasicPalette.black;
  static const PaletteEntry menuItems = BasicPalette.white;
  static const PaletteEntry menuTitleText = BasicPalette.white;
  static const PaletteEntry menuItemsText = BasicPalette.black;
  static const PaletteEntry hud = PaletteEntry(Color(0xFF00A8F3));

  static const PaletteEntry player = PaletteEntry(Color(0xFFFFFFFF));
  static const PaletteEntry playerHurt = PaletteEntry(Color(0x66FFFFFF));
  static const PaletteEntry playerShine = PaletteEntry(Color(0xBB00A8F3));
  static const PaletteEntry playerDebugRect = PaletteEntry(Color(0xFFFF2266));

  static const PaletteEntry background = PaletteEntry(Color(0xFF051C24));
  static const PaletteEntry wall = PaletteEntry(Color(0xFF003239));

  static const PaletteEntry particles = PaletteEntry(Color(0xFF00C37D));
  static const PaletteEntry particlesJetpack = PaletteEntry(Color(0xFFDDB411));
}
