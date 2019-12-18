import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'package:flame_splash_screen/flame_splash_screen.dart';

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

  GameScreen screen = GameScreen(game: game);

  runApp(MaterialApp(
          routes: {
            '/': (BuildContext ctx) => FlameSplashScreen(
                theme: FlameSplashTheme.dark,
                showBefore: (BuildContext context) {
                  return Image.asset("assets/images/fireslime-banner.png", width: 400);
                },
                onFinish: (BuildContext context) {
                  game.prepare();
                  Navigator.pushNamed(context, '/game');
                }
            ),
            '/game': (BuildContext ctx) => Scaffold(
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
