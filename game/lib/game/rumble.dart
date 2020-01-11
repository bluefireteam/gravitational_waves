import 'package:vibrate/vibrate.dart';

import 'preferences.dart';

class Rumble {
  static rumble() {
    if (!Preferences.instance.rumbleOn) return;
    Vibrate.vibrate();
  }
}
