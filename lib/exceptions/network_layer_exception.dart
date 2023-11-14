import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';
import 'package:flutter_utils_juni1289/networklayer/validator/request_validator_extension.dart';

class NetworkLayerException implements Exception {
  String cause;

  NetworkLayerException({required this.cause});
}

class NetworkLayerErrorException implements Exception {
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

  RequestCompletionHelperModel? _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return RequestCompletionStatusEnums.connectTimeOut.getRequestCompletionHelperModel();
      case DioExceptionType.sendTimeout:
        return RequestCompletionStatusEnums.sendTimeOut.getRequestCompletionHelperModel();
      case DioExceptionType.receiveTimeout:
        return RequestCompletionStatusEnums.receiveTimeOut.getRequestCompletionHelperModel();
      case DioExceptionType.cancel:
        return RequestCompletionStatusEnums.cancel.getRequestCompletionHelperModel();
      case DioExceptionType.badCertificate:
        return RequestCompletionStatusEnums.badCertificate.getRequestCompletionHelperModel();
      case DioExceptionType.badResponse:
        return RequestCompletionStatusEnums.badResponse.getRequestCompletionHelperModel();
      case DioExceptionType.connectionError:
        return RequestCompletionStatusEnums.connectionError.getRequestCompletionHelperModel();
      default:
        return RequestCompletionStatusEnums.unknownStatus.getRequestCompletionHelperModel();
    }
  }
}
