import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';

class RequestCompletionHelperModel<T> {
  String? requestResponse;
  bool isSuccess;
  RequestCompletionStatusEnums responseCompletionStatus;
  String? reason;
  T? responseWrapper;

  RequestCompletionHelperModel({this.responseWrapper, this.reason, this.requestResponse, required this.isSuccess, required this.responseCompletionStatus});
}
