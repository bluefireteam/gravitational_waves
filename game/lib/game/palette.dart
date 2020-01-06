import 'dart:ui';

import 'package:flame/palette.dart';

class Palette extends BasicPalette {
  static const PaletteEntry black = BasicPalette.black;
  static const PaletteEntry white = BasicPalette.white;

  static const PaletteEntry menuBg = BasicPalette.black;
  static const PaletteEntry menuItems = BasicPalette.white;
  static const PaletteEntry menuTitleText = BasicPalette.white;
  static const PaletteEntry menuItemsText = BasicPalette.black;
  static const PaletteEntry hud = const PaletteEntry(const Color(0xFF00A8F3));

  static const PaletteEntry player = const PaletteEntry(const Color(0xFFFFFFFF));
  static const PaletteEntry playerHurt = const PaletteEntry(const Color(0x66FFFFFF));
  static const PaletteEntry playerShine = const PaletteEntry(const Color(0xBB00A8F3));
  static const PaletteEntry playerDebugRect = const PaletteEntry(const Color(0xFFFF2266));

  static const PaletteEntry background = const PaletteEntry(const Color(0xFF051C24));
  static const PaletteEntry wall = const PaletteEntry(const Color(0xFF003239));
}