import 'package:flutter/services.dart' show HapticFeedback;

import 'preferences.dart';

class Rumble {
  static rumble() {
    if (!Preferences.instance.rumbleOn) return;
    HapticFeedback.vibrate();
  }
}
