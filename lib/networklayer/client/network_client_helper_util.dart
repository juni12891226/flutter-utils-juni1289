import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/permission/typedefs.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkClientHelperUtil {
  /// private constructor
  NetworkClientHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = NetworkClientHelperUtil._();

  ///simple method to get the DIO network client to be use
  ///to call the network APIs (Rest)
  ///all the params are provided by the API caller methods
  ///there are two types of security steps:
  ///1. SHA256 FingerPrints should match
  ///2. SHA256 Hash Security Keys should match -> optional and is based on an boolean var
  Dio getClient(
      {required bool usePrettyDioLogger,
      required List<String> allowedSHAFingerprints, //list of the allowed SHA256-Finger prints provided by the client
      required int connectTimeout,
      required int sendTimeout,
      required int receiveTimeout,
      required RequestCompletionCallback requestCompletionCallback,
      required String urlWithEndpoint, //the baseURL appended with the endpoint
      required Map<String, String> requestHeaders, //request headers to be send along the request
      required String requestMethod, // method to be specified in the caller method of the api
      required String baseURL}) {
    var options = BaseOptions(
      baseUrl: baseURL,
      // baseURL without the endpoint
      responseType: ResponseType.json,
      //response type of the request, now only JSON
      method: requestMethod,
      //request method that is POST or GET
      sendTimeout: _getAPITimeoutDurationFromPreloginConfigs(givenAPITimeoutInSeconds: sendTimeout),
      connectTimeout: _getAPITimeoutDurationFromPreloginConfigs(givenAPITimeoutInSeconds: connectTimeout),
      receiveTimeout: _getAPITimeoutDurationFromPreloginConfigs(givenAPITimeoutInSeconds: receiveTimeout),
      headers: requestHeaders,
      receiveDataWhenStatusError: true,
      followRedirects: false,
      validateStatus: (status) {
        return (status ?? 0) <= 501;
      },
    );

    var dio = Dio(options);
    if (usePrettyDioLogger) {
      dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: true, error: true, compact: true, maxWidth: 90));
    }

    return dio;
  }

  _getAPITimeoutDurationFromPreloginConfigs({required int givenAPITimeoutInSeconds}) {
    //check if given timeout value is not null
    //convert it and return

    return Duration(seconds: givenAPITimeoutInSeconds > 0 ? givenAPITimeoutInSeconds : 30);
  }
}
