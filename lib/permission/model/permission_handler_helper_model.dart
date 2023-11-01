//helper model to hold the permission grant results
//and the permission name to print in the logs

import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';

class PermissionHandlerHelperModel {
  PermissionsResultsEnums permissionsResult;
  String permissionName;

  ///[permissionsResult] is required
  ///[permissionName] is required, helps in logs
  PermissionHandlerHelperModel({required this.permissionsResult, required this.permissionName});
}
