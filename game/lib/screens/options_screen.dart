import 'package:flutter/material.dart';
import '../game/game.dart';
import '../game/preferences.dart';

import '../widgets/button.dart';

class OptionsScreen extends StatefulWidget {
  final MyGame game;

  const OptionsScreen({Key key, this.game}) : super(key: key);

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.game.widget,
        options(context),
      ],
    );
  }

  bool musicOn() => Preferences.instance.musicOn;

  bool soundOn() => Preferences.instance.soundOn;

  bool rumbleOn() => Preferences.instance.rumbleOn;

  Widget options(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                SecondaryButton(
                  label: 'Music ${musicOn() ? 'On' : 'Off'}',
                  onPress: () async {
                    await Preferences.instance.toggleMusic();
                    setState(() {});
                  },
                ),
                SecondaryButton(
                  label: 'Sound ${soundOn() ? 'On' : 'Off'}',
                  onPress: () async {
                    await Preferences.instance.toggleSounds();
                    setState(() {});
                  },
                ),
                SecondaryButton(
                  label: 'Rumble ${rumbleOn() ? 'On' : 'Off'}',
                  onPress: () async {
                    await Preferences.instance.toggleRumble();
                    setState(() {});
                  },
                ),
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
