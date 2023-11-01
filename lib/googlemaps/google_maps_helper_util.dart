import 'dart:math';

import 'package:google_maps_utils/google_maps_utils.dart';

class GoogleMapsHelperUtil {
  /// private constructor
  GoogleMapsHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = GoogleMapsHelperUtil._();

  ///To get the distance between to Points
  ///[fromLatitude] is required
  ///[fromLongitude] is required
  ///[toLatitude] is required
  ///[toLongitude] is required
  ///The distance returned will in the Meters Unit
  double getDistanceBetweenTwoPointsInMeters({required double fromLatitude, required double fromLongitude, required double toLatitude, required double toLongitude}) {
    Point from = Point(fromLatitude, fromLongitude);
    Point to = Point(toLatitude, toLongitude);
    num distance = SphericalUtils.computeDistanceBetween(from, to);
    return distance.toDouble();
  }
}
