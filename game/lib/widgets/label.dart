import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Label extends Text {
  Label({String label, Color fontColor = Colors.white, double fontSize = 12.0})
      : super(label, style: TextStyle(color: fontColor, fontSize: fontSize, fontFamily: 'Quantum'));
}
