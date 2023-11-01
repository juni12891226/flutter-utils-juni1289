import 'package:google_api_availability/google_api_availability.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/exceptions/flutter_utils_platform_exception.dart';

class GooglePlayAvailabilityHelperUtil {
  /// private constructor
  GooglePlayAvailabilityHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = GooglePlayAvailabilityHelperUtil._();

  ///to check the Google Play Services
  ///for Android only
  Future<bool> isGooglePlayServicesAvailable() async {
    if (AppHelperUtil.instance.isAndroid()) {
      var googlePlayServicesAvailability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
      if (googlePlayServicesAvailability == GooglePlayServicesAvailability.success) {
        return true;
      } else {
        return false;
      }
    } else {
      throw FlutterUtilsPlatformException(cause: "Platform exception:::isGooglePlayServicesAvailable()");
    }
  }
}
