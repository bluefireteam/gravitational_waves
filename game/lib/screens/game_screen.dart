import 'dart:io';

import 'package:flutter/material.dart';

import '../game/game.dart';
import '../game/game_data.dart';
import '../widgets/button.dart';
import '../widgets/label.dart';
import '../widgets/game_over.dart';

class GameScreen extends StatefulWidget {
  final MyGame game;

  GameScreen({this.game});

  @override
  _GameScreenState createState() => _GameScreenState(game);
}

class _GameScreenState extends State<GameScreen> {
  bool _playing = false;
  bool _playSection = false;
  bool _showGameOver = false;

  _GameScreenState(MyGame game) {
    game.backToMenu = () => this.setState(() => _playing = false);
    game.showGameOver = () {
      setState(() {
        _showGameOver = true;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(widget.game.widget);

    if (_showGameOver) {
      children.add(Center(
          child: GameOverContainer(
              distance: widget.game.score,
              gems: widget.game.coins,
              goToMainMenu: () {
                setState(() {
                  _showGameOver = false;
                  _playing = false;
                  widget.game.prepare();
                });
              },
              playAgain: () {
                setState(() {
                  _showGameOver = false;
                  widget.game.restart();
                });
              })));
    }

    if (!_playing) {
      List<Widget> sectionChildren = [];

      if (_playSection) {
        sectionChildren.addAll([
          PrimaryButton(
            label: 'Classic',
            onPress: () {
              widget.game.start();
              setState(() {
                _playSection = false;
                _playing = true;

                widget.game.start();
              });
            },
          ),
          PrimaryButton(label: 'Revamped (Soon)', onPress: null // Disabled
              ),
        ]);
      } else {
        sectionChildren.addAll([
          Label(
              label:
                  'Total Coins: ${GameData.instance.coins} | High Score: ${GameData.instance.highScore ?? '-'}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                label: 'Play',
                onPress: () {
                  setState(() => _playSection = true);
                },
              ),
              SecondaryButton(
                label: 'Options',
                onPress: () => Navigator.of(context).pushNamed('/options'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SecondaryButton(
                label: 'Skins',
                onPress: () => Navigator.of(context).pushNamed('/skins'),
              ),
              SecondaryButton(
                label: 'Scoreboard',
                onPress: () => Navigator.of(context).pushNamed('/scoreboard'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SecondaryButton(
                label: 'Credits',
                onPress: () {
                  // TODO
                },
              ),
              SecondaryButton(
                label: 'Quit',
                onPress: () => exit(0),
              ),
            ],
          ),
        ]);
      }

      children.add(
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.asset('assets/images/game_logo.png', width: 400),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: sectionChildren,
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
