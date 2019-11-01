import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() async {
  Flame.audio.disableLog();
  await Flame.util.initialDimensions();

  MyGame game = MyGame();

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
