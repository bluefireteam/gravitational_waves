import 'package:flutter/material.dart';

import '../game/game.dart';
import '../widgets/button.dart';

class SkinsScreen extends StatefulWidget {
  final MyGame game;

  const SkinsScreen({Key key, this.game}) : super(key: key);

  @override
  _SkinsScreenState createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.game.widget,
        skins(context),
      ],
    );
  }

  Widget skins(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text('skins...'),
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
