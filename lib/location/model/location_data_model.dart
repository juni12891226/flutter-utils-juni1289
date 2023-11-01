import 'package:location/location.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';

class LocationDataModel {
  LocationData? locationData;
  LocationResultsEnums locationResultsEnum;

  LocationDataModel({this.locationData, required this.locationResultsEnum});
}
