import 'package:flutter/material.dart';
import 'package:gravitational_waves/game/game.dart';

import '../widgets/button.dart';

class OptionsScreen extends StatelessWidget {
  final MyGame game;

  const OptionsScreen({Key key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        game.widget,
        options(context),
      ],
    );
  }

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
                  label: 'Music On',
                  onPress: () {
                    print('todo');
                  },
                ),
                SecondaryButton(
                  label: 'Sounds On',
                  onPress: () {
                    print('todo');
                  },
                ),
                SecondaryButton(
                  label: 'Vibrate On',
                  onPress: () {
                    print('todo');
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
