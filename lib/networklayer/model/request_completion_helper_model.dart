import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';

class RequestCompletionHelperModel {
  String? requestResponse;
  bool isSuccess;
  RequestCompletionStatusEnums responseCompletionStatus;
String? reason;
  RequestCompletionHelperModel({
    this.reason,
    this.requestResponse, required this.isSuccess, required this.responseCompletionStatus});
}
