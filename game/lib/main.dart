import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() async {
  Flame.audio.disableLog();
  Size size = await Flame.util.initialDimensions();

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
