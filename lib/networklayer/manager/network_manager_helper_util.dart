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
import 'package:flutter_utils_juni1289/networklayer/util/request_response_helper_util.dart';

class NetworkManagerHelperUtil implements RequestCompletionHelperUtil {
  void requestDioAPI(
      {required RequestCompletionCallback requestCompletionCallback,
      required RequestMethodTypesEnums requestMethodType,
      required String urlWithEndpoint,
      required String baseURL,
      Map<String, String>? requestHeaders,
      int connectTimeout = 30,
      int sendTimeout = 30,
      int receiveTimeOut = 30,
      Map<String, dynamic>? requestBody,
      bool isHideKeyboardOnAPICall = true,
      List<String>? sslSHAKeys,
      bool usePrettyDioLogger = true}) async {
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
        usePrettyDioLogger: usePrettyDioLogger,
        baseURL: baseURL,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeOut,
        sendTimeout: sendTimeout,
        allowedSHAFingerprints: sslSHAKeys,
        requestCompletionCallback: requestCompletionCallback,
        urlWithEndpoint: urlWithEndpoint,
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

    ///check network here
    NetworkConnectionManagerHelperUtil.instance.isNetworkAvailable().then((bool isNetworkAvailable) async {
      if (isNetworkAvailable) {
        if (requestMethodType == RequestMethodTypesEnums.post) {
          _processPostRequest(urlWithEndpoint,requestBody,dio,requestCompletionCallback);
        } 
      } else {
        //no network
        NetworkManagerUtils.getInstance().callCompletion("6853452354234234",
            responseBody: null,
            isSuccess: false,
            completion: requestCompletionCallback,
            responseCompletionStatus: ResponseCompletionStatus.noInternetConnection,
            actualResponseCode: 9999,
            networkManagerFailureErrorLoggerHelperModel:
                NetworkManagerFailureErrorLoggerHelperModel(urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
      }
    });
  }

  @override
  RequestCompletionHelperModel getRequestCompletionHelperModel({required Response responseFromServer}) {
    int statusCodeFromServer = responseFromServer.statusCode ?? 0;
    try {
      if (statusCodeFromServer == NetworkLayerConstants.success) {
        if (_isValidResponseJson(responseFromServer)) {
          //success
          return RequestCompletionHelperModel(
              requestResponse: AppHelperUtil.instance.getEncodedJSONString(toEncode: responseFromServer.data.toString()),
              reason: "Success (200).",
              responseCompletionStatus: RequestCompletionStatusEnums.success,
              isSuccess: true);
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
        return RequestCompletionHelperModel(
            reason: "Unknown status code from server.", responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus, isSuccess: false);
      }
    } catch (exp) {
      throw NetworkLayerException(cause: "NetworkExceptionError:::$exp");
    }
  }

  bool _isValidResponseJson(Response responseFromServer) {
    if (responseFromServer != null && responseFromServer.data != null && responseFromServer.data.runtimeType == String && responseFromServer.data.toString().isNotEmpty) {
      ///decoding the string to json
      dynamic json = AppHelperUtil.instance.getDecodedJSON(responseBody: responseFromServer.data.toString());
      if (json != null && json is Map) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> _processPostRequest(String urlWithEndpoint, Map<String, dynamic>? requestBody, Dio dio, RequestCompletionCallback requestCompletionCallback) async{
    ///method for calling POST type APIs
    ///includes MAY or MAY NOT request body
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dio.post(urlWithEndpoint, data: requestBody ?? {}).then((Response responseFromServer) {
        var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
        requestStopWatchTimer.stop();

        requestCompletionCallback(requestCompletionHelperModel: getRequestCompletionHelperModel(responseFromServer: responseFromServer));
      }).catchError((dioError, stackTrace) {

      });
    } on DioException catch (dioException) {

    }
  }
}
