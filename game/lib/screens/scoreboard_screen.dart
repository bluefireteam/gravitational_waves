import 'package:flutter/material.dart';

import '../game/game.dart';
import '../game/game_data.dart';
import '../game/scoreboard.dart';
import '../widgets/button.dart';
import '../widgets/label.dart';
import '../widgets/palette.dart';

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
                FutureBuilder(
                  future: Future.wait([
                    ScoreBoard.fetchScoreboard(),
                  ]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active: {
                        return Center(
                          child: Label(label: 'Loading results...'),
                        );
                      }
                      case ConnectionState.done: {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Center(
                            child: Label(label: 'Could not fetch scoreboard.'),
                          );
                        }
                        return showScoreboard(context, GameData.instance.playerId, snapshot.data[0] as List<ScoreBoardEntry>);
                      }
                    }
                    throw 'Invalid connection state ${snapshot.connectionState}';
                  },
                ),
                PrimaryButton(
                  label: 'Back',
                  onPress: () => Navigator.of(context).pop(),
                ),
                SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showScoreboard(BuildContext context, String playerId, List<ScoreBoardEntry> entries) {
    Color fontColor(ScoreBoardEntry entry) =>
      entry.playerId == playerId ? PaletteColors.blues.light : PaletteColors.blues.normal;

    final _list = ListView(
        padding: const EdgeInsets.all(10),
        children: (entries ?? []).asMap().entries.map((entry) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            color: entry.value.playerId == playerId ? const Color(0xFF38607C) : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 5),
                      // TODO show skin used
                      Label(
                        fontColor: fontColor(entry.value),
                        label: '#${entry.key + 1}',
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Label(
                          label: '${entry.value.playerId}',
                          fontSize: 14,
                          fontColor: fontColor(entry.value),
                        ),
                        SizedBox(width: 20),
                        Label(
                          label: '${entry.value.score}',
                          fontSize: 14,
                          fontColor: fontColor(entry.value),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
      }).toList(),
    );

    if (playerId == null) {
      return Flexible(
        child: Column(
          children: [
            SizedBox(height: 50),
            SecondaryButton(
              label: 'Join the scoreboard',
              onPress: () => Navigator.pushReplacementNamed(context, '/join-scoreboard'),
            ),
            Expanded(child: _list),
          ],
        ),
      );
    } else {
      return Flexible(child: _list);
    }
  }
}
