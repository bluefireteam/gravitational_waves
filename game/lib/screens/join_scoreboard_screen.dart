import 'package:flutter/material.dart';

import '../game/game.dart';
import '../game/game_data.dart';
import '../game/scoreboard.dart';
import '../game/util.dart';
import '../widgets/button.dart';
import '../widgets/gr_container.dart';
import '../widgets/label.dart';
import '../widgets/palette.dart';

class JoinScoreboardScreen extends StatefulWidget {
  final MyGame game;

  const JoinScoreboardScreen({Key key, this.game}) : super(key: key);

  @override
  _JoinScoreboardScreenState createState() => _JoinScoreboardScreenState();
}

class _JoinScoreboardScreenState extends State<JoinScoreboardScreen> {
  final playerIdTextController = TextEditingController();

  String _status = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    playerIdTextController.dispose();
    super.dispose();
  }

  Future<bool> _checkPlayerIdAvailability() async {
    if (playerIdTextController.text.isEmpty) {
      setState(() => _status = 'Player id cannot be empty');
      return false;
    }

    setState(() => _status = 'Checking...');

    try {
      final isPlayerIdAvailable = !CHECK_PLAYER_ID ||
          await ScoreBoard.isPlayerIdAvailable(playerIdTextController.text);

      setState(() {
        _status = isPlayerIdAvailable
            ? 'Player id available'
            : 'Player id already in use';
      });

      return isPlayerIdAvailable;
    } catch (e) {
      setState(() => _status = 'Error');
    }

    return false;
  }

  void _join() async {
    final isPlayerIdAvailable = await _checkPlayerIdAvailability();

    if (isPlayerIdAvailable) {
      await GameData.instance.setPlayerId(playerIdTextController.text);
      await ScoreBoard.submitScore(GameData.instance.highScore,
          forceSubmission: true);

      Navigator.pushReplacementNamed(context, "/scoreboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.game.widget,
        joinScoreboard(context),
      ],
    );
  }

  Widget joinScoreboard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GRContainer(
            width: 500,
            child: Column(
              children: [
                SizedBox(height: 20),
                Label(
                    label: 'Choose your player ID:',
                    fontSize: 22,
                    fontColor: PaletteColors.pinks.light),
                Container(
                  width: 400,
                  child: TextField(
                    controller: playerIdTextController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: PaletteColors.blues.light),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: PaletteColors.blues.light),
                      ),
                    ),
                    style: TextStyle(
                        fontFamily: 'Quantum',
                        color: PaletteColors.blues.light),
                  ),
                ),
                SizedBox(height: 10),
                Label(
                    fontSize: 12,
                    label:
                        """By joining the scoreboard you agree that we collect your score,
your selected player skin and the choosen player id on the field above.
Those informations are only used for the display of the scoreboard.
                      """,
                    fontColor: PaletteColors.blues.light),
                SizedBox(height: 10),
              ],
            )),
        Column(
          children: [
            Label(label: _status, fontColor: PaletteColors.pinks.light),
            SecondaryButton(
              label: 'Check availability',
              onPress: _checkPlayerIdAvailability,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              PrimaryButton(
                label: 'Join',
                onPress: _join,
              ),
              SecondaryButton(
                label: 'Cancel',
                onPress: () => Navigator.of(context).pop(),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
