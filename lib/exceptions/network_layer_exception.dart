import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';
import 'package:flutter_utils_juni1289/networklayer/validator/request_validator_extension.dart';

class NetworkLayerException implements Exception {
  String cause;

  NetworkLayerException({required this.cause});
}

class NetworkLayerErrorException implements Exception{
  RequestCompletionHelperModel? failure;

  NetworkLayerErrorException.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure = RequestCompletionStatusEnums.unknownStatus.getRequestCompletionHelperModel();
    }
  }

  RequestCompletionHelperModel _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return RequestCompletionStatusEnums.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return RequestCompletionStatusEnums.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return RequestCompletionStatusEnums.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null &&
            error.response?.statusCode != null &&
            error.response?.statusMessage != null) {
          return RequestCompletionHelperModel(error.response?.statusCode ?? 0,
              error.response?.statusMessage ?? "");
        } else {
          return RequestCompletionStatusEnums.DEFAULT.getFailure();
        }
      case DioExceptionType.cancel:
        return RequestCompletionStatusEnums.CANCEL.getFailure();
      default:
        return RequestCompletionStatusEnums.DEFAULT.getFailure();
    }
  }
}