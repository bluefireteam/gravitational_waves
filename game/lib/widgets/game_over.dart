import 'package:flutter/widgets.dart';
import 'gr_container.dart';
import 'label.dart';
import 'palette.dart';
import 'button.dart';

class _Line extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;

  _Line(this.leftLabel, this.rightLabel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Label(
                label: '$leftLabel',
                fontSize: 22,
                fontColor: PaletteColors.blues.dark,
                textAlign: TextAlign.end)),
        SizedBox(width: 20),
        Expanded(
            child: Label(
                label: '$rightLabel',
                fontSize: 22,
                fontColor: PaletteColors.blues.light)),
      ],
    );
  }
}

class GameOverContainer extends StatelessWidget {
  final int distance;
  final int gems;
  final void Function() goToMainMenu;
  final void Function() playAgain;

  GameOverContainer(
      {this.distance, this.gems, this.goToMainMenu, this.playAgain});

  @override
  Widget build(BuildContext context) {
    return GRContainer(
        width: 350,
        height: 280,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Label(
              label: 'Game Over',
              fontSize: 36,
              fontColor: PaletteColors.blues.dark),
          SizedBox(height: 20),
          _Line('Gems', '$gems'),
          _Line('Distance', '$distance'),
          SizedBox(height: 20),
          PrimaryButton(label: 'Play again', onPress: playAgain),
          SecondaryButton(label: 'Back to menu', onPress: goToMainMenu),
        ]));
  }
}
