import 'package:firebase_analytics/firebase_analytics.dart';

enum EventName {
  APP_OPEN,
  START_CLASSIC,
  START_REVAMPED,
  REWARD,
}

String enumName(EventName enumVal) {
  return enumVal.toString().split('.').last;
}

class Analytics {
  static void log(EventName eventName) {
    try {
      FirebaseAnalytics().logEvent(name: enumName(eventName).toLowerCase());
    } catch (ex) {
      print('Unexpected error sending alalytics:');
      print(ex);
    }
  }
}
