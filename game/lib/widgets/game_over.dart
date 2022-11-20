import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'button.dart';
import 'gr_container.dart';
import 'label.dart';
import 'palette.dart';

class _Line extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;

  const _Line(this.leftLabel, this.rightLabel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Label(
            label: leftLabel,
            fontSize: 22,
            fontColor: PaletteColors.blues.dark,
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Label(
            label: rightLabel,
            fontSize: 22,
            fontColor: PaletteColors.blues.light,
          ),
        ),
      ],
    );
  }
}

class GameOverContainer extends StatefulWidget {
  static const WIDTH = 350.0;
  static const HEIGHT = 320.0;

  final int distance;
  final int gems;
  final bool showExtraLifeButton;
  final void Function() goToMainMenu;
  final void Function() playAgain;
  final void Function() extraLife;

  const GameOverContainer({
    required this.distance,
    required this.gems,
    required this.showExtraLifeButton,
    required this.goToMainMenu,
    required this.playAgain,
    required this.extraLife,
  });

  @override
  State<GameOverContainer> createState() => _GameOverContainerState();
}

class _GameOverContainerState extends State<GameOverContainer> {
  late final keyboardListenerFocusNode = FocusNode();

  @override
  void initState() {
    keyboardListenerFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: keyboardListenerFocusNode,
      autofocus: true,
      onKeyEvent: (keyEvent) {
        if (keyEvent is KeyDownEvent &&
            keyEvent.logicalKey == LogicalKeyboardKey.space) {
          widget.playAgain();
        }
      },
      child: GRContainer(
        width: GameOverContainer.WIDTH,
        height: GameOverContainer.HEIGHT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label(
              label: 'Game Over',
              fontSize: 36,
              fontColor: PaletteColors.blues.dark,
            ),
            const SizedBox(height: 20),
            _Line('Gems', '${widget.gems}'),
            _Line('Distance', '${widget.distance}'),
            const SizedBox(height: 20),
            if (widget.showExtraLifeButton)
              PrimaryButton(
                label: 'Extra life (ad)',
                onPress: widget.extraLife,
              ),
            PrimaryButton(label: 'Play again', onPress: widget.playAgain),
            SecondaryButton(
              label: 'Back to menu',
              onPress: widget.goToMainMenu,
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverLoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const GRContainer(
      width: GameOverContainer.WIDTH,
      height: GameOverContainer.HEIGHT,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
