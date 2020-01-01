import 'package:flutter/material.dart';

import '../game/game.dart';
import '../widgets/button.dart';

class ScoreboardScreen extends StatefulWidget {
  final MyGame game;

  const ScoreboardScreen({Key key, this.game}) : super(key: key);

  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.game.widget,
        scoreboard(context),
      ],
    );
  }

  Widget scoreboard(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text('scoreboard...'),
                PrimaryButton(
                  label: 'Back',
                  onPress: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
