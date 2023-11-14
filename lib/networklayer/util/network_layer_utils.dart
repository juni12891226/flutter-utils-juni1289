import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';
import 'package:flutter_utils_juni1289/networklayer/typedefs/typedefs.dart';

abstract class NetworkLayerUtils {
  bool isValidResponseJson(Response responseFromServer);

  RequestCompletionHelperModel onRequestCompletionGetHelperModel({required Response responseFromServer});

  Future<void> processPostRequest(
      {required String urlWithEndpoint, Map<String, dynamic>? requestBody, required Dio dioInstance, required RequestCompletionCallback requestCompletionCallback});
}
