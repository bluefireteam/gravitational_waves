import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import './widgets/button.dart';

void main() {
  final dashbook = Dashbook();

  dashbook
      .storiesOf('Button')
      .decorator(CenterDecorator())
      .add('default', Button(label: 'Play', onPress: () {}))
      .add('primary', PrimaryButton(label: 'Play', onPress: () {}))
      .add('secondary', SecondaryButton(label: 'Play', onPress: () {}));

  runApp(dashbook);
}
