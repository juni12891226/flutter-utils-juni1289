import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';

extension RequestValidatorExtension on RequestCompletionStatusEnums {
  RequestCompletionHelperModel? getRequestCompletionHelperModel() {
    switch (this) {
      case RequestCompletionStatusEnums.badCertificate:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.badCertificate);
      case RequestCompletionStatusEnums.badResponse:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.badResponse);
      case RequestCompletionStatusEnums.connectTimeOut:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.connectTimeOut);
      case RequestCompletionStatusEnums.cancel:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.cancel);
      case RequestCompletionStatusEnums.receiveTimeOut:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.receiveTimeOut);
      case RequestCompletionStatusEnums.sendTimeOut:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.sendTimeOut);
      case RequestCompletionStatusEnums.connectionError:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.connectionError);
      default:
        return RequestCompletionHelperModel(isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus);
    }
  }
}
