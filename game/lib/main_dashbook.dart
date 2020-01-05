import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import 'package:flame/flame.dart';

import './widgets/button.dart';
import './widgets/label.dart';
import './widgets/spritesheet_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dashbook = Dashbook();

  dashbook
      .storiesOf('Button')
      .decorator(CenterDecorator())
      .add('default', (_) => Button(label: 'Play', onPress: () {}))
      .add('primary', (_) => PrimaryButton(label: 'Play', onPress: () {}))
      .add('secondary', (_) => SecondaryButton(label: 'Play', onPress: () {}));

  final spriteSheet = await Flame.images.load('container-tileset.png');

  dashbook
      .storiesOf('SpritesheetContainer')
      .decorator(CenterDecorator())
      .add('default', (ctx) => Container(
              width: ctx.numberProperty("width", 100),
              height: ctx.numberProperty("height", 100),
              child: SpritesheetContainer(
                  spriteSheet: spriteSheet,
                  tileSize: 16,
                  destTileSize: 50,

                  child: Center(child: Label(label: "Cool label")),
              ))
      );

  runApp(dashbook);
}
