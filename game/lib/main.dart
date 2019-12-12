import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import './game/assets/tileset.dart';
import './game/assets/char.dart';
import './game/game.dart';

import './screens/game_screen.dart';

void main() async {
  Flame.initializeWidget();

  Flame.audio.disableLog();
  if (debugDefaultTargetPlatformOverride != TargetPlatform.fuchsia) {
    await Flame.util.setLandscape();
  }
  Size size = await Flame.util.initialDimensions();
  await Future.wait([Tileset.init(), Char.init()]);

  MyGame game = MyGame(size);
  game.prepare();

  GameScreen screen = GameScreen(game: game);

  runApp(MaterialApp(
    routes: {
      '/': (BuildContext ctx) => Scaffold(
              body: WillPopScope(
            onWillPop: () async {
              screen.game.pause();
              return false;
            },
            child: screen,
          )),
    },
  ));
}
