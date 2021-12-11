import 'dart:ui';

class PaletteColors {
  static final greens = PaletteGreens();
  static final blues = PaletteBlues();
  static final pinks = PalettePinks();
}

class PaletteGreens {
  final light = const Color(0xFF00c37d);
  final normal = const Color(0xFF07865c);
  final dark = const Color(0xFF003339);
}

class PaletteBlues {
  final light = const Color(0xFF00a8f3);
  final normal = const Color(0xFF0047ed);
  final dark = const Color(0xFF001953);
}

class PalettePinks {
  final light = const Color(0xFFc259df);
  final normal = const Color(0xFF8f27b8);
  final dark = const Color(0xFF5e0d24);
}
