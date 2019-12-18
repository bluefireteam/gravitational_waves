import 'package:flutter/material.dart';

import './palette.dart';

typedef OnPress = void Function();

class PrimaryButton extends Button {

  PrimaryButton({ String label, OnPress onPress }): super(
      label: label,
      onPress: onPress,
      fontColor: PaletteColors.pinks.normal,
      backgroundColor: PaletteColors.blues.light,
  );
}

class SecondaryButton extends Button {

  SecondaryButton({ String label, OnPress onPress }): super(
      label: label,
      onPress: onPress,
      fontColor: PaletteColors.blues.light,
      backgroundColor: PaletteColors.pinks.normal,
  );
}

class Button extends StatelessWidget {

  final String label;
  final OnPress onPress;
  final double minWidth;

  final Color fontColor;
  final Color backgroundColor;

  Button({ this.label, this.onPress, this.fontColor, this.backgroundColor, this.minWidth = 200 });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: ButtonTheme(minWidth: minWidth, height: 50, child: FlatButton(
                color: fontColor,
                onPressed: onPress,
                child: Text(
                    label,
                    style: TextStyle(
                        color: backgroundColor,
                        fontFamily: "Quantum",
                        fontSize: 34,
                    )
                ),
        ))
    );
  }
}
