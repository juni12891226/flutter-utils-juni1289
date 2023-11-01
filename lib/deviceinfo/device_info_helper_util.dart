import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/changecase/string_change_case_helper_util.dart';
import 'package:flutter_utils_juni1289/exceptions/device_info_helper_util_exception.dart';
import 'package:flutter_utils_juni1289/exceptions/flutter_utils_platform_exception.dart';

class DeviceInfoHelperUtil {
  /// private constructor
  DeviceInfoHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = DeviceInfoHelperUtil._();

  ///Get the device id
  ///Id of the device on which app is currently running
  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (AppHelperUtil.instance.isAndroid()) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.id;
      } else if (AppHelperUtil.instance.isIOS()) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      } else {
        return "";
      }
    } on PlatformException {
      throw DeviceInfoHelperUtilException(cause: "Platform exception:::getDeviceId()");
    }
    return null;
  }

  ///Get the device maker brand name samsung, one plus...
  ///Device maker brand name of the device on which app is currently running
  Future<String?> getDeviceMakerBrandName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (AppHelperUtil.instance.isAndroid()) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.model;
      } else if (AppHelperUtil.instance.isIOS()) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.localizedModel;
      }
    } on PlatformException {
      throw DeviceInfoHelperUtilException(cause: "Platform exception:::getDeviceMakerBrandName()");
    }
    return null;
  }

  ///Get the device OS Version
  ///OS Version of the device on which app is currently running
  Future<String?> getDeviceOSVersion() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (AppHelperUtil.instance.isAndroid()) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.version.release;
      } else if (AppHelperUtil.instance.isIOS()) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.systemVersion;
      }
    } on PlatformException {
      throw DeviceInfoHelperUtilException(cause: "Platform exception:::getDeviceOSVersion()");
    }
    return null;
  }

  ///Get the currently running device type name in string type param
  ///[stringChangeCaseEnum] is for getting the desired string case for the device type name string
  ///ANDROID => Android or android or aNDROID
  String getDeviceTypeNameString({StringChangeCaseEnums? stringChangeCaseEnum}) {
    String deviceTypeName = AppHelperUtil.instance.isAndroid() ? "ANDROID" : "IOS";

    return stringChangeCaseEnum != null
        ? StringChangeCaseHelperUtil.instance.changeCase(givenString: deviceTypeName, stringChangeCaseEnum: stringChangeCaseEnum)
        : deviceTypeName;
  }

  ///Get the Android SDK version
  Future<int?> getAndroidSDKVersion() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (AppHelperUtil.instance.isAndroid()) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.version.sdkInt;
      }
    } on PlatformException {
      throw DeviceInfoHelperUtilException(cause: "Platform exception:::getAndroidVersion()");
    }
    return null;
  }

  ///Get the App version
  Future<String?> getAppVersionForUI() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (AppHelperUtil.instance.isAndroid()) {
      return packageInfo.version;
    } else if (AppHelperUtil.instance.isIOS()) {
      return "${packageInfo.version}.${packageInfo.buildNumber}";
    } else {
      throw FlutterUtilsPlatformException(cause: "Platform exception:::getAppVersionForUI()");
    }
  }
}
