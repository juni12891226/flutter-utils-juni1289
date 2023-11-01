import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsHelperUtil {
  FirebaseAnalytics? _analytics;

  /// private constructor
  FirebaseAnalyticsHelperUtil._() {
    _analytics = FirebaseAnalytics.instance;
  }

  /// the one and only instance of this singleton
  static final instance = FirebaseAnalyticsHelperUtil._();

  void logFirebaseEvent({required String eventName, Map<String, dynamic>? parameters, Function(String eventName, String reason, Map params)? onEventLoggedCallback}) {
    _logEvent(eventName: eventName, parameters: parameters, onEventLoggedCallback: onEventLoggedCallback);
  }

  void _logEvent({required String eventName, Map<String, dynamic>? parameters, Function(String eventName, String reason, Map params)? onEventLoggedCallback}) {
    if (!kReleaseMode) {
      if (onEventLoggedCallback != null) {
        onEventLoggedCallback(eventName, "Not a release build!", parameters ?? {});
      }
      return;
    }

    ///log firebase analytics
    if (_analytics != null) {
      _analytics!.logEvent(name: eventName, parameters: parameters).then((_) {
        if (onEventLoggedCallback != null) {
          onEventLoggedCallback(eventName, "Success!", parameters ?? {});
        }
      });
    } else {
      if (onEventLoggedCallback != null) {
        onEventLoggedCallback(eventName, "Failed, the Analytics Object is null!", parameters ?? {});
      }
    }
  }
}
