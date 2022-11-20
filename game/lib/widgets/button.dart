import 'package:flutter/material.dart';

import 'palette.dart';

typedef OnPress = void Function();

class PrimaryButton extends Button {
  PrimaryButton({required String label, OnPress? onPress})
      : super(
          label: label,
          onPress: onPress,
          fontColor: PaletteColors.pinks.normal,
          backgroundColor: PaletteColors.blues.light,
        );
}

class SecondaryButton extends Button {
  SecondaryButton({required String label, OnPress? onPress})
      : super(
          label: label,
          onPress: onPress,
          fontColor: PaletteColors.blues.light,
          backgroundColor: PaletteColors.pinks.normal,
        );
}

class Button extends StatelessWidget {
  final String label;
  final OnPress? onPress;
  final double minWidth;

  final Color? fontColor;
  final Color? backgroundColor;

  const Button({
    required this.label,
    this.onPress,
    this.fontColor,
    this.backgroundColor,
    this.minWidth = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.5),
      child: ButtonTheme(
        minWidth: minWidth,
        // TODO(luan): replace FlatButton
        // ignore_for_file: deprecated_member_use
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: fontColor),
          onPressed: onPress,
          child: Text(
            label,
            style: TextStyle(
              color: backgroundColor,
              fontFamily: 'Quantum',
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}
