import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import './main.dart' as game;

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  game.main();
}
