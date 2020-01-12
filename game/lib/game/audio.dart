import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/audio_pool.dart';
import 'package:flame/flame.dart';
import 'package:gravitational_waves/game/preferences.dart';

import 'util.dart';

class Audio {
  static final Map<String, AudioPool> pools = {
    'coin.wav':
        AudioPool('coin.wav', minPlayers: 2, maxPlayers: 2, repeating: false),
    'die.wav':
        AudioPool('die.wav', minPlayers: 1, maxPlayers: 1, repeating: false),
  };

  static final AudioCache musicPlayer = _createLoopingPlayer(prefix: 'audio/');

  static AudioCache _createLoopingPlayer({String prefix}) {
    AudioPlayer player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.LOOP);
    return AudioCache(prefix: prefix, fixedPlayer: player);
  }

  static Future init() async {
    Flame.audio.disableLog();
    if (!ENABLE_AUDIO) return;
    await Future.wait(pools.values.map((p) => p.init()));
  }

  static void coin() {
    sfx('coin.wav', volume: 0.5);
  }

  static void die() {
    sfx('die.wav');
  }

  static Stoppable sfx(String sound, {double volume = 1.0}) {
    if (!ENABLE_AUDIO) return () {};
    if (!Preferences.instance.soundOn) return () {};
    final close = _startAsync(sound, volume: volume);
    return () async => (await close)();
  }

  static Future<Stoppable> _startAsync(String sound, {double volume}) {
    return pools[sound].start(volume: volume);
  }

  static void music(String song) async {
    if (!ENABLE_AUDIO) return;
    if (!Preferences.instance.musicOn) return;
    await musicPlayer.play('music/$song');
  }

  static void stopMusic() async {
    await musicPlayer.fixedPlayer.stop();
  }

  static void pauseMusic() async {
    await musicPlayer.fixedPlayer.pause();
  }

  static void resumeMusic() async {
    await musicPlayer.fixedPlayer.resume();
  }

  static void startMusic() async {
    return music('dark-moon.mp3');
  }
}
