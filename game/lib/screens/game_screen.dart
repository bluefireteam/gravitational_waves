import 'package:flutter/material.dart';

import '../game/game.dart';

import '../widgets/button.dart';

class GameScreen extends StatefulWidget {

  final MyGame game;

  GameScreen({ this.game });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  bool _playing = false;

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
                    Image.asset("assets/images/game_logo.png", width: 400),
                    Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrimaryButton(
                              label: "Play",
                              onPress: () {
                                widget.game.start();
                                setState(() {
                                  _playing = true;
                                });
                              }
                          ),
                          SecondaryButton(
                              label: "Quit",
                              onPress: () {
                                // TODO
                              }
                          ),
                          SizedBox(height: 50),
                      ]
                    ))
                  ]
              )
          )

      );
    }

    return Stack(children: children );
  }
}
