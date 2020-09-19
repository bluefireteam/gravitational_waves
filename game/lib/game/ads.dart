import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:oktoast/oktoast.dart';

import 'util.dart';

class Ads {
  static bool _loaded;

  static Future<void> init() async {
    if (ENABLE_ADS) {
      const appId = 'ca-app-pub-1572179540677968~2049628478';
      const adUnitId = 'ca-app-pub-1572179540677968/7034539450';
      final result1 = await FirebaseAdMob.instance.initialize(appId: appId);
      if (!result1) {
        _loaded = false;
        return;
      }
      final result2 = await RewardedVideoAd.instance.load(adUnitId: adUnitId);
      _loaded = result2;
    }
  }

  static Future<bool> showAd() async {
    if (!ENABLE_ADS) {
      return Future.value(false);
    }

    if (!_loaded) {
      showToast('There was an error while loading the ad.');
      return Future.value(false);
    }

    final promise = Completer<bool>();

    RewardedVideoAd.instance.listener = (
      RewardedVideoAdEvent event, {
      String rewardType,
      int rewardAmount,
    }) {
      if (event == RewardedVideoAdEvent.rewarded) {
        promise.complete(true);
      } else {
        print('Error rewarding ad: $event');
        showToast('You did not finish watching the ad.');
        promise.complete(false);
      }
    };

    try {
      final result = await RewardedVideoAd.instance.show();
      if (!result) {
        showToast('There was an error while loading the ad.');
        promise.complete(false);
      }
    } catch (ex) {
      print('Unexpected error while loading ad: $ex');
      showToast('Unexpected error while loading the ad.');
      promise.complete(false);
    }

    return promise.future;
  }
}
