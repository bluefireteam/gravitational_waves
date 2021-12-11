import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'palette.dart';

final R = math.Random();

const ENABLE_AUDIO = true;
const DEBUG = false;
const CHECK_PLAYER_ID = false;
const ENABLE_REVAMP = true;
const ENABLE_ADS = true;

const BLOCK_SIZE = 16.0;
const BLOCK_SIZE_INT = 16;
const CHUNCK_SIZE = 64;

const ROTATION_SPEED = 0.075;

const STARS_SPEED = 5.0;
const STARS_IDLE_SPEED = 2.0;
const PLANET_SPEED = 45.0;
const SHIPS_SPEED = 45.0;
const PLAYER_SPEED = 170.0;
const GRAVITY_ACC = 2750.0;

const STARTING_LIVES = 1;
const SUCTION_SPEED = 35.0;

class Fonts {
  static final TextPaint _base = TextPaint(
    style: TextStyle(fontFamily: 'Quantum'),
  );
  static final TextPaint menuTitle = _base.copyWith(
    (it) => it.copyWith(fontSize: 64.0, color: Palette.menuTitleText.color),
  );
  static final TextPaint menuItems = _base.copyWith(
    (it) => it.copyWith(fontSize: 28.0, color: Palette.menuItemsText.color),
  );
  static final TextPaint gameOverItems = _base.copyWith(
    (it) => it.copyWith(fontSize: 16.0, color: Palette.menuItemsText.color),
  );
  static final TextPaint hud = _base.copyWith(
    (it) => it.copyWith(fontSize: 16.0, color: Palette.hud.color),
  );
  static final TextPaint tutorial = _base.copyWith(
    (it) => it.copyWith(fontSize: 24.0, color: Palette.hud.color),
  );
}
