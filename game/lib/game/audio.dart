import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';

import 'preferences.dart';
import 'util.dart';

class Audio {
  static final AudioCache musicPlayer = _createLoopingPlayer(
    prefix: 'assets/audio/',
  );

  static AudioCache _createLoopingPlayer({required String prefix}) {
    final player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.LOOP);
    return AudioCache(prefix: prefix, fixedPlayer: player);
  }

  static Future init() async {
    if (!ENABLE_AUDIO) {
      return;
    }
  }

  static void coin() {
    sfx('coin.wav', volume: 0.5);
  }

  static void die() {
    sfx('die.wav');
  }

  static void sfx(String sound, {double volume = 1.0}) {
    if (!ENABLE_AUDIO) {
      return;
    }
    if (!Preferences.instance.soundOn) {
      return;
    }

    FlameAudio.play('sfx/$sound');
  }

  static void music(String song) async {
    if (!ENABLE_AUDIO) {
      return;
    }
    if (!Preferences.instance.musicOn) {
      return;
    }
    await musicPlayer.play('music/$song');
  }

  static void stopMusic() async {
    await musicPlayer.fixedPlayer?.stop();
  }

  static void pauseMusic() async {
    await musicPlayer.fixedPlayer?.pause();
  }

  static void resumeMusic() async {
    await musicPlayer.fixedPlayer?.resume();
  }

  static void gameMusic() async {
    return music('dark-moon.mp3');
  }

  static void menuMusic() async {
    return music('contemplative-breaks.mp3');
  }
}
