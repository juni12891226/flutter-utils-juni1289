import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:location/location.dart';

class LocationDataModel {
  LocationData? locationData;
  LocationResultsEnums locationResultsEnum;

  LocationDataModel({this.locationData, required this.locationResultsEnum});
}
