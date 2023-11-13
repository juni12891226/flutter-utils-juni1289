import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';

abstract class RequestCompletionHelperUtil{
  RequestCompletionHelperModel getRequestCompletionHelperModel({required Response responseFromServer});
}