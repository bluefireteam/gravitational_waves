import 'package:flutter/material.dart';

import '../game/game.dart';

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
                    SizedBox(height: 25),
                    Image.asset("assets/images/game_logo.png", width: 400),
                    RaisedButton(
                        child: Text("Play"),
                        onPressed: () {
                          widget.game.start();
                          setState(() {
                            _playing = true;
                          });
                        }
                    ),
                    RaisedButton(
                        child: Text("Quit"),
                        onPressed: () {
                          // TODO
                        }
                    )
                  ]
              )
          )

      );
    }

    return Stack(children: children );
  }
}
