import 'dart:io';

import 'package:flutter/material.dart';

import '../game/game.dart';
import '../game/game_data.dart';
import '../widgets/button.dart';
import '../widgets/label.dart';

class GameScreen extends StatefulWidget {
  final MyGame game;

  GameScreen({this.game});

  @override
  _GameScreenState createState() => _GameScreenState(game);
}

class _GameScreenState extends State<GameScreen> {
  bool _playing = false;

  _GameScreenState(MyGame game) {
    game.backToMenu = () => this.setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(widget.game.widget);

    if (!_playing) {
      children.add(
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset('assets/images/game_logo.png', width: 400),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          label: 'Classic',
                          onPress: () {
                            widget.game.start();
                            setState(() => _playing = true);
                          },
                        ),
                        PrimaryButton(
                          label: 'Revamped',
                          onPress: null, // disabled
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SecondaryButton(
                        label: 'Skins',
                        onPress: () =>
                            Navigator.of(context).pushNamed('/skins'),
                        ),
                        SecondaryButton(
                          label: 'Scoreboard',
                          onPress: () =>
                              Navigator.of(context).pushNamed('/scoreboard'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SecondaryButton(
                          label: 'Options',
                          onPress: () =>
                              Navigator.of(context).pushNamed('/options'),
                        ),
                        SecondaryButton(
                          label: 'Quit',
                          onPress: () => exit(0),
                        ),
                      ],
                    ),
                    Label(label: 'Total Coins: ${GameData.instance.coins} | High Score: ${GameData.instance.highScore}'),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Stack(children: children);
  }
}
