import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';
import 'package:flutter_utils_juni1289/networklayer/responsewrapper/generics_util.dart';
import 'package:flutter_utils_juni1289/networklayer/typedefs/typedefs.dart';

abstract class RequestValidatorHelperUtil {
  Future<void> processPostRequest<T extends Decodable>(
      {required String baseURL,
      required String apiEndPoint,
      Map<String, dynamic>? requestBody,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      required bool showRawLogs});

  bool isValidResponseJson(Response responseFromServer);

  RequestCompletionHelperModel onRequestCompletionGetHelperModel<T extends Decodable>(
      {required Response responseFromServer, CreateModelClassCallback<T>? createModelClassCallback});
}
