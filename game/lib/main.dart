import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import './assets/tileset.dart';
import 'assets/char.dart';
import 'game.dart';

void main() async {
  Flame.initializeWidget();

  Flame.audio.disableLog();
  if (debugDefaultTargetPlatformOverride != TargetPlatform.fuchsia) {
    await Flame.util.setLandscape();
  }
  Size size = await Flame.util.initialDimensions();
  await Future.wait([Tileset.init(), Char.init()]);

  MyGame game = MyGame(size);

  runApp(MaterialApp(
    routes: {
      '/': (BuildContext ctx) => Scaffold(
              body: WillPopScope(
            onWillPop: () async {
              game.pause();
              return false;
            },
            child: game.widget,
          )),
    },
  ));
}
