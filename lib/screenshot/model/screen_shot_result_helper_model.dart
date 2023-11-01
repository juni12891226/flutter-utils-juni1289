import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';

class ScreenShotHelperModel {
  String? savedImagePath;
  PermissionsResultsEnums? permissionsResultsEnum;
  String? errorReason;
  bool saveSuccess;

  ScreenShotHelperModel({this.savedImagePath, this.errorReason, this.permissionsResultsEnum, required this.saveSuccess});
}
