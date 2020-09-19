import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../game/ads.dart';
import '../game/audio.dart';
import '../game/game.dart';
import '../game/game_data.dart';
import '../game/util.dart';
import '../widgets/button.dart';
import '../widgets/game_over.dart';
import '../widgets/label.dart';
import '../widgets/slide_in_container.dart';

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
  bool _adLoading = false;

  _GameScreenState(MyGame game) {
    game.backToMenu = () => setState(() => _playing = false);
    game.showGameOver = (bool show) {
      setState(() => _showGameOver = show);
    };
  }

  void startGame({bool enablePowerups}) {
    widget.game.start();
    setState(() {
      _playSection = false;
      _playing = true;

      widget.game.powerups.enabled = enablePowerups;
      widget.game.start();
    });
  }

  void handleExtraLife() async {
    if (widget.game.hasUsedExtraLife) {
      print('You arealdy used your extra life.');
      return;
    }
    setState(() => _adLoading = true);
    final result = await Ads.showAd();
    if (result) {
      widget.game.gainExtraLife();
    }
    setState(() => _adLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(widget.game.widget);

    if (_showGameOver) {
      children.add(
        Center(
          child: SlideInContainer(
            from: Offset(0.0, 1.5),
            duration: Duration(milliseconds: 500),
            child: _adLoading
                ? GameOverLoadingContainer()
                : GameOverContainer(
                    distance: widget.game.score,
                    gems: widget.game.coins,
                    showExtraLifeButton:
                        !widget.game.hasUsedExtraLife && Ads.adLoaded(),
                    goToMainMenu: () {
                      setState(() {
                        _showGameOver = false;
                        _playing = false;
                        widget.game.prepare();
                        Audio.menuMusic();
                      });
                    },
                    playAgain: () {
                      setState(() {
                        _showGameOver = false;
                        widget.game.restart();
                      });
                    },
                    extraLife: handleExtraLife,
                  ),
          ),
        ),
      );
    }

    if (!_playing) {
      List<Widget> sectionChildren = [];

      if (_playSection) {
        sectionChildren.addAll([
          SlideInContainer(
            from: Offset(-2.0, 0.0),
            duration: Duration(milliseconds: 500),
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Classic',
                  onPress: () => startGame(enablePowerups: false),
                ),
                PrimaryButton(
                  label: ENABLE_REVAMP ? 'Revamped' : 'Revamped (Soon)',
                  onPress: ENABLE_REVAMP
                      ? () => startGame(enablePowerups: true)
                      : null,
                ),
                SecondaryButton(
                  label: 'Back',
                  onPress: () => setState(() => _playSection = false),
                ),
              ],
            ),
          ),
        ]);
      } else {
        sectionChildren.addAll([
          Label(
            label:
                'Total Coins: ${GameData.instance.coins} | High Score: ${GameData.instance.highScore ?? '-'}',
          ),
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
                onPress: () => Navigator.of(context).pushNamed('/credits'),
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
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: SlideInContainer(
                  from: const Offset(0.0, -1.5),
                  child: Image.asset('assets/images/game_logo.png', width: 400),
                ),
              ),
              Expanded(
                child: SlideInContainer(
                  from: const Offset(0.0, 1.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: sectionChildren,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(children: children);
  }
}
