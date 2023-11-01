import 'dart:math';

import 'package:location/location.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/location/model/location_data_model.dart';
import 'package:flutter_utils_juni1289/permission/helper/permission_helper_util.dart';
import 'package:flutter_utils_juni1289/permission/model/permission_handler_helper_model.dart';

class LocationHelperUtil {
  /// private constructor
  LocationHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = LocationHelperUtil._();

  Future<LocationDataModel?> getCurrentLocationData() async {
    bool isEnabled = await isLocationServiceEnabled();

    if (!isEnabled) {
      isEnabled = await requestEnableLocationService();
    }

    if (isEnabled) {
      PermissionHandlerHelperModel? permissionHandlerHelperModel = await PermissionHelperUtil.instance.checkIfLocationPermissionGranted();
      if (permissionHandlerHelperModel == null) {
        AppHelperUtil.instance.showLog("LocationHelper:::juni1289:::Permission Helper Model is null!");
        return LocationDataModel(locationData: null, locationResultsEnum: LocationResultsEnums.permissionHelperModelIsNull);
      }

      if (permissionHandlerHelperModel.permissionsResult == PermissionsResultsEnums.granted) {
        //get location here
        LocationData locationData = await Location().getLocation();
        return LocationDataModel(locationData: locationData, locationResultsEnum: LocationResultsEnums.permissionGranted);
      } else if (permissionHandlerHelperModel.permissionsResult == PermissionsResultsEnums.denied) {
        AppHelperUtil.instance.showLog("LocationHelper:::juni1289:::Permission Denied!");
        return LocationDataModel(locationData: null, locationResultsEnum: LocationResultsEnums.permissionDenied);
      } else if (permissionHandlerHelperModel.permissionsResult == PermissionsResultsEnums.permanentlyDenied) {
        AppHelperUtil.instance.showLog("LocationHelper:::juni1289:::Permission Permanently Denied!");
        return LocationDataModel(locationData: null, locationResultsEnum: LocationResultsEnums.permissionPermanentlyDenied);
      } else {
        AppHelperUtil.instance.showLog("LocationHelper:::juni1289:::Permission Unknown Issue!");
        return LocationDataModel(locationData: null, locationResultsEnum: LocationResultsEnums.unknownIssue);
      }
    } else {
      AppHelperUtil.instance.showLog("LocationHelper:::juni1289:::Service Disabled");
      return LocationDataModel(locationData: null, locationResultsEnum: LocationResultsEnums.locationServicesDisabled);
    }
  }

  ///to enable the location service
  ///GPS Service
  Future<bool> requestEnableLocationService() async {
    return await Location().requestService();
  }

  ///to check if the GPS is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Location().serviceEnabled();
  }

  ///to get the distance between the 2 points for latitudes and longitudes
  double calculateDistanceBetweenTwoPoints({required double latitude1, required double longitude1, required double latitude2, required double longitude2}) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((latitude1 - latitude1) * p) / 2 + c(latitude1 * p) * c(latitude1 * p) * (1 - c((longitude2 - longitude1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
