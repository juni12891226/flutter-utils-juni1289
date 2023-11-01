import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/permission/model/permission_handler_helper_model.dart';

class PermissionHelperUtil {
  /// private constructor
  PermissionHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = PermissionHelperUtil._();

  ///Notifications Permission
  Future<PermissionHandlerHelperModel?> checkIfNotificationsPermissionGranted() async {
    PermissionHandlerHelperModel? permissionHandlerHelperModel;
    String permissionName = "Permission.notification";

    Map<Permission, PermissionStatus> statuses = await [Permission.notification].request();

    if (statuses.isNotEmpty && statuses[Permission.notification] != null && statuses[Permission.notification]!.isGranted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.granted, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.notification] != null && statuses[Permission.notification]!.isDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.denied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.notification] != null && statuses[Permission.notification]!.isPermanentlyDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.permanentlyDenied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.notification] != null && statuses[Permission.notification]!.isRestricted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.isRestricted, permissionName: permissionName);
    }

    return permissionHandlerHelperModel;
  }

  ///Microphone Permission
  Future<PermissionHandlerHelperModel?> checkIfMicPermissionGranted() async {
    PermissionHandlerHelperModel? permissionHandlerHelperModel;
    String permissionName = "Permission.microphone";

    Map<Permission, PermissionStatus> statuses = await [Permission.microphone].request();

    if (statuses.isNotEmpty && statuses[Permission.microphone] != null && statuses[Permission.microphone]!.isGranted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.granted, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.microphone] != null && statuses[Permission.microphone]!.isDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.denied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.microphone] != null && statuses[Permission.microphone]!.isPermanentlyDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.permanentlyDenied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.microphone] != null && statuses[Permission.microphone]!.isRestricted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.isRestricted, permissionName: permissionName);
    }

    return permissionHandlerHelperModel;
  }

  ///Location Permission
  Future<PermissionHandlerHelperModel?> checkIfLocationPermissionGranted() async {
    PermissionHandlerHelperModel? permissionHandlerHelperModel;
    String permissionName = "Permission.location";

    Map<Permission, PermissionStatus> statuses = await [Permission.location].request();

    if (statuses.isNotEmpty && statuses[Permission.location] != null && statuses[Permission.location]!.isGranted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.granted, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.location] != null && statuses[Permission.location]!.isDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.denied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.location] != null && statuses[Permission.location]!.isPermanentlyDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.permanentlyDenied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.location] != null && statuses[Permission.location]!.isRestricted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.isRestricted, permissionName: permissionName);
    }

    return permissionHandlerHelperModel;
  }

  ///Contacts Permission
  Future<PermissionHandlerHelperModel?> checkIfContactsPermissionGranted() async {
    PermissionHandlerHelperModel? permissionHandlerHelperModel;
    String permissionName = "Permission.contacts";

    Map<Permission, PermissionStatus> statuses = await [Permission.contacts].request();

    if (statuses.isNotEmpty && statuses[Permission.contacts] != null && statuses[Permission.contacts]!.isGranted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.granted, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.contacts] != null && statuses[Permission.contacts]!.isDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.denied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.contacts] != null && statuses[Permission.contacts]!.isPermanentlyDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.permanentlyDenied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.contacts] != null && statuses[Permission.contacts]!.isRestricted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.isRestricted, permissionName: permissionName);
    }

    return permissionHandlerHelperModel;
  }

  ///Storage Permission
  ///For androidVersion >= 33
  Future<PermissionHandlerHelperModel?> checkIfStoragePermissionGranted() async {
    PermissionHandlerHelperModel? permissionHandlerHelperModel;
    String permissionName = "Permission.storage";

    //get the android version
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    var build = await deviceInfoPlugin.androidInfo;
    int androidVersion = 9999;
    try {
      androidVersion = build.version.sdkInt;
    } catch (exp) {
      AppHelperUtil.instance.showLog("PermissionHelper.juni1289:::AndroidVersion:::Exception:::$exp");
    }
    AppHelperUtil.instance.showLog("PermissionHelper.juni1289:::AndroidVersion:::$androidVersion");

    Map<Permission, PermissionStatus> statuses = await [Permission.storage, Permission.photos].request();

    if (statuses.isNotEmpty && statuses[Permission.storage] != null && statuses[Permission.storage]!.isGranted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.granted, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.storage] != null && statuses[Permission.storage]!.isDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.denied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.storage] != null && statuses[Permission.storage]!.isPermanentlyDenied) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.permanentlyDenied, permissionName: permissionName);
    } else if (statuses.isNotEmpty && statuses[Permission.storage] != null && statuses[Permission.storage]!.isRestricted) {
      permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.isRestricted, permissionName: permissionName);
    }

    if (Platform.isIOS || (androidVersion != 9999) && androidVersion >= 33) {
      if (statuses.isNotEmpty && statuses[Permission.photos] != null && statuses[Permission.photos]!.isGranted) {
        permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.granted, permissionName: permissionName);
      } else if (statuses.isNotEmpty && statuses[Permission.photos] != null && statuses[Permission.photos]!.isDenied) {
        permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.denied, permissionName: permissionName);
      } else if (statuses.isNotEmpty && statuses[Permission.photos] != null && statuses[Permission.photos]!.isPermanentlyDenied) {
        permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.permanentlyDenied, permissionName: permissionName);
      } else if (statuses.isNotEmpty && statuses[Permission.photos] != null && statuses[Permission.photos]!.isRestricted) {
        permissionHandlerHelperModel = PermissionHandlerHelperModel(permissionsResult: PermissionsResultsEnums.isRestricted, permissionName: permissionName);
      }
    }

    return permissionHandlerHelperModel;
  }
}
