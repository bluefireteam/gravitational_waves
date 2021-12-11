import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride, kIsWeb;
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import './game/assets/char.dart';
import './game/assets/tileset.dart';
import './screens/credits_screen.dart';
import './screens/game_screen.dart';
import './screens/join_scoreboard_screen.dart';
import './screens/options_screen.dart';
import './screens/skins_screen.dart';
import 'game/ads.dart';
import 'game/analytics.dart';
import 'game/assets/poofs.dart';
import 'game/audio.dart';
import 'game/game_data.dart';
import 'game/preferences.dart';
import 'screens/scoreboard_screen.dart';
import 'widgets/assets/ui_tileset.dart';

void main() async {
  print('Starting app...');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAwyHBokdzuZcW_iQ6hu_7DCrP6_DclSqg',
      authDomain: 'fireslime-gravity-runner.firebaseapp.com',
      databaseURL: 'https://fireslime-gravity-runner.firebaseio.com',
      projectId: 'fireslime-gravity-runner',
      storageBucket: 'fireslime-gravity-runner.appspot.com',
      messagingSenderId: '107315711863',
      appId: '1:107315711863:web:1c84176903b93eb824db72',
      measurementId: 'G-E1SGKDJLF4',
    ),
  );

  await setMobileOrientation();

  final setup = Future.wait([
    Preferences.init(),
    GameData.init(),
  ]).then((_) {
    return Future.wait([
      Audio.init(),
      Ads.init(),
      Tileset.init(),
      Char.init(),
      Poofs.init(),
      UITileset.init(),
    ]);
  });

  await setup;

  Analytics.log(EventName.APP_OPEN);
  Audio.menuMusic();

  runApp(
    OKToast(
      child: MaterialApp(
        routes: {
          '/': (BuildContext ctx) => FlameSplashScreen(
                theme: FlameSplashTheme.dark,
                showBefore: (BuildContext context) {
                  return Image.asset(
                    'assets/images/fireslime-banner.png',
                    width: 400,
                  );
                },
                onFinish: (BuildContext context) {
                  Navigator.pushNamed(context, '/game');
                },
              ),
          '/options': (BuildContext ctx) =>
              const Scaffold(body: OptionsScreen()),
          '/skins': (BuildContext ctx) => const Scaffold(body: SkinsScreen()),
          '/scoreboard': (BuildContext ctx) => const Scaffold(
                body: ScoreboardScreen(),
              ),
          '/join-scoreboard': (BuildContext ctx) => const Scaffold(
                body: JoinScoreboardScreen(),
              ),
          '/credits': (BuildContext ctx) => const Scaffold(
                body: CreditsScreen(),
              ),
          '/game': (BuildContext ctx) => Scaffold(
                body: GameScreen(),
              ),
        },
      ),
    ),
  );
}

Future<void> setMobileOrientation() async {
  if (!kIsWeb) {
    if (debugDefaultTargetPlatformOverride != TargetPlatform.fuchsia) {
      await Flame.device.setLandscape();
    }
    await Flame.device.fullScreen();
  }
}
