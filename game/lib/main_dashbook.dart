import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import 'package:flame/flame.dart';

import './widgets/button.dart';
import './widgets/label.dart';
import './widgets/spritesheet_container.dart';
import './widgets/game_over.dart';
import './widgets/assets/ui_tileset.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UITileset.load();
  final dashbook = Dashbook();

  dashbook
      .storiesOf('Button')
      .decorator(CenterDecorator())
      .add('default', (_) => Button(label: 'Play', onPress: () {}))
      .add('primary', (_) => PrimaryButton(label: 'Play', onPress: () {}))
      .add('secondary', (_) => SecondaryButton(label: 'Play', onPress: () {}));

  dashbook
      .storiesOf('SpritesheetContainer')
      .decorator(CenterDecorator())
      .add('default', (ctx) => Container(
              width: ctx.numberProperty("width", 100),
              height: ctx.numberProperty("height", 100),
              child: SpritesheetContainer(
                  spriteSheet: UITileset.tileset,
                  tileSize: 16,
                  destTileSize: 50,

                  child: Center(child: Label(label: "Cool label")),
              ))
      );

  dashbook
      .storiesOf('GameOver')
      .decorator(CenterDecorator())
      .add('default', (_) => GameOverContainer(distance: 100, gems: 20, playAgain: () {}, goToMainMenu: () {}));

  runApp(dashbook);
}
