import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/exceptions/network_layer_exception.dart';
import 'package:flutter_utils_juni1289/network/connectionmanager/network_connection_manager_helper_util.dart';
import 'package:flutter_utils_juni1289/networklayer/client/network_client_helper_util.dart';
import 'package:flutter_utils_juni1289/networklayer/model/request_completion_helper_model.dart';
import 'package:flutter_utils_juni1289/networklayer/typedefs/typedefs.dart';
import 'package:flutter_utils_juni1289/networklayer/util/constants.dart';
import 'package:flutter_utils_juni1289/networklayer/validator/request_validator_helper_util.dart';

class NetworkManagerHelperUtil implements RequestValidatorHelperUtil {
  ///Main caller method for requesting Dio APIs
  ///[requestCompletionCallback] is required
  ///[requestMethodType] is required, ENUMs -> for specifying the API method type
  ///[baseURL] is required, the Base URL pointing to the server
  ///[apiEndPoint] is required, the path of the API endpoint
  ///[requestHeaders] is optional
  ///[requestBody] is optional
  ///[connectTimeoutSecs] is optional, default is 30 Seconds
  ///[sendTimeoutSecs] is optional, default is 30 Seconds
  ///[receiveTimeoutSecs] is optional, default is 30 Seconds
  ///[dioInterceptors] is optional, is a list of Interceptors you want to add any of your own Interceptor
  ///[showRawLogs] is optional, default is set to false, to show the Dio Network Layer logs
  ///[isHideKeyboardOnAPICall] is optional, default is true, to hide the keyboard on each API call
  Future<void> requestDioAPI(
      {required RequestCompletionCallback requestCompletionCallback,
      required RequestMethodTypesEnums requestMethodType,
      required String baseURL,
      required String apiEndPoint,
      Map<String, dynamic>? requestHeaders,
      Map<String, dynamic>? requestBody,
      int connectTimeoutSecs = 30,
      int sendTimeoutSecs = 30,
      int receiveTimeoutSecs = 30,
      bool isHideKeyboardOnAPICall = true,
      List<Interceptor>? dioInterceptors,
      bool showRawLogs = false}) async {
    if (isHideKeyboardOnAPICall) {
      ///hide keyboard
      AppHelperUtil.instance.hideKeyboard();
    }

    ///there are two levels of security
    ///1. SHA256 FingerPrints should match
    ///2. SHA256 Hash Security Keys should match -> optional and is based on an boolean var

    ///get the network client from the util
    ///provided with the allowed SHA256 FingerPrints
    ///the very first layer of the security over the network layer
    ///that is if the SHA256 Finger prints will match only
    ///then the API gets onto next level
    Dio dio = NetworkClientHelperUtil.instance.getClient(
        baseURL: baseURL,
        connectTimeoutSecs: connectTimeoutSecs,
        receiveTimeoutSecs: receiveTimeoutSecs,
        sendTimeoutSecs: sendTimeoutSecs,
        requestCompletionCallback: requestCompletionCallback,
        apiEndPoint: apiEndPoint,
        requestHeaders: requestHeaders ?? {},
        requestMethod: requestMethodType);

    dio.httpClientAdapter = IOHttpClientAdapter(
      onHttpClientCreate: (_) {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
        return client;
      },
      // validateCertificate: (cert, host, port) {
      //   // Check that the cert fingerprint matches the one we expect.
      //   // We definitely require _some_ certificate.
      //   if (cert == null) {
      //     return false;
      //   }
      //   // Validate it any way you want. Here we only check that
      //   // the fingerprint matches the OpenSSL SHA256.
      //   bool valid = "8af954997043f60f932f899ce5474b2c695e4ea434a91acb3f47e2c41c942c3e" == sha256.convert(cert.der).toString();
      //   return valid;
      // },
    );

    //check network here
    NetworkConnectionManagerHelperUtil.instance.isNetworkAvailable().then((bool isNetworkAvailable) async {
      if (isNetworkAvailable) {
        if (requestMethodType == RequestMethodTypesEnums.post) {
          processPostRequest(
              showRawLogs: showRawLogs,
              baseURL: baseURL,
              apiEndPoint: apiEndPoint,
              requestBody: requestBody,
              dioInstance: dio,
              requestCompletionCallback: requestCompletionCallback);
        }
      } else {
        //no network
        requestCompletionCallback(RequestCompletionHelperModel(
            reason:"No Internet Connection Available!",
            isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.noInternetConnection));
      }
    });
  }

  ///When the server responds, that is when the request completes (success | failure)
  ///Checks the status code from the server response
  ///Checks the server response if valid or not that is if valid JSON and is mappable
  ///[responseFromServer] is required
  @override
  RequestCompletionHelperModel onRequestCompletionGetHelperModel({required Response responseFromServer}) {
    int statusCodeFromServer = responseFromServer.statusCode ?? 0;
    if (statusCodeFromServer == NetworkLayerConstants.success) {
      if (isValidResponseJson(responseFromServer)) {
        //success
        return RequestCompletionHelperModel(
            requestResponse: responseFromServer.data.toString(), reason: "Success (200).", responseCompletionStatus: RequestCompletionStatusEnums.success, isSuccess: true);
      } else {
        //request response in invalid, null or empty or json has errors
        return RequestCompletionHelperModel(
            reason: "Request response is not valid.", responseCompletionStatus: RequestCompletionStatusEnums.requestResponseInValid, isSuccess: false);
      }
    } else if (statusCodeFromServer == NetworkLayerConstants.badRequest) {
      return RequestCompletionHelperModel(reason: "Bad Request (400).", responseCompletionStatus: RequestCompletionStatusEnums.badRequest, isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.noContent) {
      return RequestCompletionHelperModel(reason: "No content (201).", responseCompletionStatus: RequestCompletionStatusEnums.noContent, isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.unAuthorised) {
      return RequestCompletionHelperModel(reason: "UnAuthorised (401).", responseCompletionStatus: RequestCompletionStatusEnums.unAuthorised, isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.forbidden) {
      return RequestCompletionHelperModel(reason: "Forbidden (403).", responseCompletionStatus: RequestCompletionStatusEnums.forbidden, isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.internalServerError) {
      return RequestCompletionHelperModel(
          reason: "Internal Server Error (500).", responseCompletionStatus: RequestCompletionStatusEnums.internalServerError, isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.notFound) {
      return RequestCompletionHelperModel(reason: "Not found (404).", responseCompletionStatus: RequestCompletionStatusEnums.notFound, isSuccess: false);
    } else {
      //unknown result code
      return RequestCompletionHelperModel(reason: "Unknown status code from server.", responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus, isSuccess: false);
    }
  }

  ///Validate the response from the server
  ///If the response returned from server is a valid JSON and is mappable
  ///[responseFromServer] is required param, the Dio Response
  @override
  bool isValidResponseJson(Response responseFromServer) {
    if (responseFromServer.data != null) {
      //decoding the string to json
      dynamic json = AppHelperUtil.instance.getDecodedJSON(responseBody: AppHelperUtil.instance.getEncodedJSONString(toEncode: responseFromServer.data));
      if (json != null && json is Map) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///method for calling POST type APIs
  ///MAY or MAY NOT include the request body
  ///[baseURL] is required, only using in Raw logs
  ///[apiEndPoint] is required
  ///[dioInstance] is required
  ///[requestCompletionCallback] is required for the API complete callback
  ///[showRawLogs] is optional, to show the Dio network layer logs
  ///[requestBody] is optional for POST request
  @override
  Future<void> processPostRequest(
      {required String baseURL,
      required String apiEndPoint,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      Map<String, dynamic>? requestBody,
      bool showRawLogs = false}) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance.post(apiEndPoint, data: requestBody ?? {}).then((Response responseFromServer) {
        var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
        requestStopWatchTimer.stop();

        //process the response validation
        requestCompletionCallback(onRequestCompletionGetHelperModel(responseFromServer: responseFromServer));
        //show the time taken by the API call
        AppHelperUtil.instance.showLog("URL:::$baseURL$apiEndPoint elapsedTimeDuration:::$elapsedTimeDuration", logKey: "DioX", isReleaseMode: showRawLogs ? false : true);
        AppHelperUtil.instance
            .showLog("URL:::$baseURL$apiEndPoint RawResponseFromServer:::${responseFromServer.data}", logKey: "DioX", isReleaseMode: showRawLogs ? false : true);
      });
    } on DioException catch (dioException) {
      AppHelperUtil.instance.showLog("URL:::$baseURL$apiEndPoint RawExceptionFromDio:::${dioException.error}", logKey: "DioX", isReleaseMode: showRawLogs ? false : true);
      requestCompletionCallback((NetworkLayerErrorException.handle(dioException).failure) ??
          RequestCompletionHelperModel(reason: "DioException has been thrown!", isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus));
    }
  }
}
