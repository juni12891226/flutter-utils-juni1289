import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_utils_juni1289/apputil/app_util_helper.dart';
import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';
import 'package:flutter_utils_juni1289/network/connectionmanager/network_connection_manager_helper_util.dart';
import 'package:flutter_utils_juni1289/networklayer/client/network_client_helper_util.dart';
import 'package:flutter_utils_juni1289/networklayer/typedefs/typedefs.dart';
import 'package:dio/io.dart';

class NetworkManagerHelperUtil {
  void requestDioAPI({
    required RequestCompletionCallback requestCompletionCallback,
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
    bool usePrettyDioLogger=true
  }) async {
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
          ///method for calling POST type APIs
          ///includes MAY or MAY NOT request body
          try {
            var requestStopWatchTimer = Stopwatch();
            requestStopWatchTimer.start();
            await dio.post(urlWithEndpoint, data: requestBody ?? {}).then((Response responseFromServer) {
              var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
              requestStopWatchTimer.stop();

              if((responseFromServer.statusCode ?? "") == 200){
                requestCompletionCallback();
              }

              if ((responseFromServer.statusCode ?? "") == 403 || (encryptedResponseFromServer?.statusCode ?? "") == 404) {
                NetworkManagerUtils.getInstance().callCompletion("35234234231234556",
                    responseBody: encryptedResponseFromServer.toString(),
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                    actualResponseCode: encryptedResponseFromServer.statusCode,
                    networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                        dioResponse: encryptedResponseFromServer,
                        apiRequestElapsedTime: elapsedTimeDuration,
                        decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
              } else if ((encryptedResponseFromServer?.statusCode ?? "") == RequestStatusCodesConstants.loginAuthTokenInvalidated) {
                NetworkManagerUtils.getInstance().showNetworkAPICallLogs(NetworkManagerLoggerHelperModel(
                    dioResponse: encryptedResponseFromServer, apiRequestElapsedTime: elapsedTimeDuration, decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                //session auth token is expired
                //call refresh API
                callRefreshLoginAuthToken(
                    onForeground: onForeground,
                    completion: (bool success) {
                      if (success) {
                        AppUtil.showLog(LoggerConstants.dioLoggerKey, "Session Auth Token API Completed!");
                        callDioAPI(
                            isCommonPayloadRequired: false,
                            onForeground: onForeground,
                            requestMethod: RequestMethodConstants.post,
                            urlWithEndpoint: urlWithEndpoint,
                            requestHeaders: NetworkManagerUtils.getInstance().getRequestDefaultHeaders(),
                            requestBody: encryptedJSON,
                            isEncryptionDone: NetworkResponseKeysConstants.isEncryptionDone,
                            requestCompletionCallback: requestCompletionCallback);
                      } else {
                        AppUtil.showLog(LoggerConstants.dioLoggerKey, "Session Auth Token API Failed!");

                        ///any error from the Network Layer
                        NetworkManagerUtils.getInstance().callCompletion("890890890",
                            responseBody: null,
                            success: false,
                            completion: requestCompletionCallback,
                            responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                            actualResponseCode: 9999,
                            networkManagerFailureErrorLoggerHelperModel: NetworkManagerFailureErrorLoggerHelperModel(
                                urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
                      }
                    });
              } else if ((encryptedResponseFromServer?.statusCode ?? "") == RequestStatusCodesConstants.appForceUpdate) {
                String requestResponse = "";

                ///check if encrypted request or not
                ///if request is encrypted, so as the response
                ///perform the decryption then
                ///if request is simple and not encrypted, do not perform
                ///the decryption on the response returned from the server
                if (isEncryptionDone) {
                  requestResponse = CryptoUtil.decrypt(
                      (AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject) ?? "")
                          .replaceAll("\"", "")
                          .replaceAll('"', ""));
                } else {
                  requestResponse = AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject);
                }

                NetworkManagerUtils.getInstance().callCompletion("89023123",
                    responseBody: requestResponse,
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.appForceUpdate,
                    actualResponseCode: encryptedResponseFromServer.statusCode,
                    networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                        dioResponse: encryptedResponseFromServer,
                        apiRequestElapsedTime: elapsedTimeDuration,
                        decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
              } else if ((encryptedResponseFromServer?.statusCode ?? "") == RequestStatusCodesConstants.refreshTokenInvalidated) {
                NetworkManagerUtils.getInstance().callCompletion("8908422220",
                    responseBody: encryptedResponseFromServer.toString(),
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                    actualResponseCode: encryptedResponseFromServer.statusCode,
                    networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                        dioResponse: encryptedResponseFromServer,
                        apiRequestElapsedTime: elapsedTimeDuration,
                        decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                //the refresh token API has return 411
                //as the refresh token is expired | wrong | invalidated
                //redirect the user to the login screen
                UserDataManager.getInstance().redirectToLoginScreenOnRefreshTokenExpiry();
              } else {
                //else case for 403, 404, 410 ,411
                String requestResponse = "";

                ///check if encrypted request or not
                ///if request is encrypted, so as the response
                ///perform the decryption then
                ///if request is simple and not encrypted, do not perform
                ///the decryption on the response returned from the server
                if (isEncryptionDone) {
                  requestResponse = CryptoUtil.decrypt(
                      (AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject) ?? "")
                          .replaceAll("\"", "")
                          .replaceAll('"', ""));
                } else {
                  requestResponse = AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject);
                }
                if (requestResponse != null && requestResponse.toString().isNotEmpty && requestResponse.toString() != null) {
                  NetworkManagerUtils.getInstance().callCompletion("890864363450",
                      responseBody: requestResponse,
                      success: true,
                      completion: requestCompletionCallback,
                      responseCompletionStatus: ResponseCompletionStatus.completedWithoutError,
                      actualResponseCode: encryptedResponseFromServer.statusCode,
                      networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                          dioResponse: encryptedResponseFromServer,
                          apiRequestElapsedTime: elapsedTimeDuration,
                          decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                } else {
                  NetworkManagerUtils.getInstance().callCompletion("890890890090989",
                      responseBody: null,
                      success: false,
                      completion: requestCompletionCallback,
                      responseCompletionStatus: ResponseCompletionStatus.requestNullEmptyOrResponseCodeNotAvailable,
                      actualResponseCode: encryptedResponseFromServer.statusCode,
                      networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                          dioResponse: encryptedResponseFromServer,
                          apiRequestElapsedTime: elapsedTimeDuration,
                          decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                }
              } //else case ends for 403, 404, 410
            }).catchError((error, stackTrace) {
              AppUtil.showLog(LoggerConstants.dioLoggerKey, "OnError:::0000:::$error StackTrace:::$stackTrace");
              if (error != null && error.toString().toLowerCase().contains("Failed to parse header value".toLowerCase())) {
                //refresh the token
                //call the get gateway token
                //replace the token in the local app session
                //proceed, call the preceding API
                //which has been failed due to the gateway token expiry
                AppUtil.showLog(LoggerConstants.dioLoggerKey, "Error:::***HttpException: Failed to parse header value***");
                requestGenerateGateWayToken(completion: (bool success) {
                  if (success) {
                    AppUtil.showLog(LoggerConstants.dioLoggerKey, "Gateway Auth Token API Completed!");
                    callDioAPI(
                        isCommonPayloadRequired: false,
                        onForeground: onForeground,
                        requestMethod: RequestMethodConstants.post,
                        urlWithEndpoint: urlWithEndpoint,
                        requestHeaders: NetworkManagerUtils.getInstance().getRequestDefaultHeaders(),
                        requestBody: encryptedJSON,
                        isEncryptionDone: NetworkResponseKeysConstants.isEncryptionDone,
                        requestCompletionCallback: requestCompletionCallback);
                  } else {
                    AppUtil.showLog(LoggerConstants.dioLoggerKey, "Gateway Auth Token API Failed!");

                    ///any error from the Network Layer
                    NetworkManagerUtils.getInstance().callCompletion("890890890112333",
                        responseBody: null,
                        success: false,
                        completion: requestCompletionCallback,
                        responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                        actualResponseCode: 9999,
                        networkManagerFailureErrorLoggerHelperModel: NetworkManagerFailureErrorLoggerHelperModel(
                            urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
                  }
                });
              } else {
                NetworkManagerUtils.getInstance().callCompletion("3423232435644422",
                    responseBody: null,
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                    actualResponseCode: 9999,
                    networkManagerFailureErrorLoggerHelperModel: NetworkManagerFailureErrorLoggerHelperModel(
                        urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
              }
            });
          } on DioError catch (ex) {
            AppUtil.showLog(LoggerConstants.dioLoggerKey, "DioError:::1111:::${ex.message}");

            NetworkManagerUtils.getInstance().callCompletion("734534322234234",
                responseBody: null,
                success: false,
                completion: requestCompletionCallback,
                responseCompletionStatus: ResponseCompletionStatus.completedWithDIOError,
                actualResponseCode: 9999,
                networkManagerFailureErrorLoggerHelperModel:
                    NetworkManagerFailureErrorLoggerHelperModel(urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
          }
        } else {
          ///method for calling GET type APIs
          ///includes NO request body
          try {
            var requestStopWatchTimer = Stopwatch();
            requestStopWatchTimer.start();
            await dio
                .get(
              urlWithEndpoint,
            )
                .then((encryptedResponseFromServer) {
              var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
              requestStopWatchTimer.stop();

              ///check network layer related issues
              ///403 is if the token is invalid
              ///404 is if the URL in invalid
              ///410 is if the session auth token in expired or invalid
              ///that is in 410 case call the refresh auth token API
              if ((encryptedResponseFromServer?.statusCode ?? "") == 403 || (encryptedResponseFromServer?.statusCode ?? "") == 404) {
                NetworkManagerUtils.getInstance().callCompletion("235232343334343",
                    responseBody: encryptedResponseFromServer.toString(),
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                    actualResponseCode: encryptedResponseFromServer.statusCode,
                    networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                        dioResponse: encryptedResponseFromServer,
                        apiRequestElapsedTime: elapsedTimeDuration,
                        decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
              } else if ((encryptedResponseFromServer?.statusCode ?? "") == RequestStatusCodesConstants.loginAuthTokenInvalidated) {
                NetworkManagerUtils.getInstance().showNetworkAPICallLogs(NetworkManagerLoggerHelperModel(
                    dioResponse: encryptedResponseFromServer, apiRequestElapsedTime: elapsedTimeDuration, decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                //session auth token is expired
                //call refresh API
                callRefreshLoginAuthToken(
                    onForeground: onForeground,
                    completion: (bool success) {
                      if (success) {
                        AppUtil.showLog(LoggerConstants.dioLoggerKey, "Session Auth Token API Completed!");
                        callDioAPI(
                            isCommonPayloadRequired: false,
                            onForeground: onForeground,
                            requestMethod: RequestMethodConstants.post,
                            urlWithEndpoint: urlWithEndpoint,
                            requestHeaders: NetworkManagerUtils.getInstance().getRequestDefaultHeaders(),
                            requestBody: encryptedJSON,
                            isEncryptionDone: NetworkResponseKeysConstants.isEncryptionDone,
                            requestCompletionCallback: requestCompletionCallback);
                      } else {
                        AppUtil.showLog(LoggerConstants.dioLoggerKey, "Session Auth Token API Failed!");

                        ///any error from the Network Layer
                        NetworkManagerUtils.getInstance().callCompletion("345346332324234",
                            responseBody: null,
                            success: false,
                            completion: requestCompletionCallback,
                            responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                            actualResponseCode: 9999,
                            networkManagerFailureErrorLoggerHelperModel: NetworkManagerFailureErrorLoggerHelperModel(
                                urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
                      }
                    });
              } else if ((encryptedResponseFromServer?.statusCode ?? "") == RequestStatusCodesConstants.appForceUpdate) {
                String requestResponse = "";

                ///check if encrypted request or not
                ///if request is encrypted, so as the response
                ///perform the decryption then
                ///if request is simple and not encrypted, do not perform
                ///the decryption on the response returned from the server
                if (isEncryptionDone) {
                  requestResponse = CryptoUtil.decrypt(
                      (AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject) ?? "")
                          .replaceAll("\"", "")
                          .replaceAll('"', ""));
                } else {
                  requestResponse = AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject);
                }

                NetworkManagerUtils.getInstance().callCompletion("2346898703452",
                    responseBody: requestResponse,
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.appForceUpdate,
                    actualResponseCode: encryptedResponseFromServer.statusCode,
                    networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                        dioResponse: encryptedResponseFromServer,
                        apiRequestElapsedTime: elapsedTimeDuration,
                        decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
              } else if ((encryptedResponseFromServer?.statusCode ?? "") == RequestStatusCodesConstants.refreshTokenInvalidated) {
                NetworkManagerUtils.getInstance().callCompletion("643242342564576",
                    responseBody: encryptedResponseFromServer.toString(),
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                    actualResponseCode: encryptedResponseFromServer.statusCode,
                    networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                        dioResponse: encryptedResponseFromServer,
                        apiRequestElapsedTime: elapsedTimeDuration,
                        decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                //the refresh token API has return 411
                //as the refresh token is expired | wrong | invalidated
                //redirect the user to the login screen
                UserDataManager.getInstance().redirectToLoginScreenOnRefreshTokenExpiry();
              } else {
                String requestResponse = "";

                ///check if encrypted request or not
                ///if request is encrypted, so as the response
                ///perform the decryption then
                ///if request is simple and not encrypted, do not perform
                ///the decryption on the response returned from the server
                if (isEncryptionDone) {
                  requestResponse = CryptoUtil.decrypt(
                      (AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject) ?? "")
                          .replaceAll("\"", "")
                          .replaceAll('"', ""));
                } else {
                  requestResponse = AppUtil.getEncodedJSONString(encryptedResponseFromServer?.data ?? PreferencesPreDefinedDefaultValues.nullOrEmptyDefaultResponseObject);
                }

                if (requestResponse != null && requestResponse.toString().isNotEmpty && requestResponse.toString() != null) {
                  NetworkManagerUtils.getInstance().callCompletion("2342324123123",
                      responseBody: requestResponse,
                      success: true,
                      completion: requestCompletionCallback,
                      responseCompletionStatus: ResponseCompletionStatus.completedWithoutError,
                      actualResponseCode: encryptedResponseFromServer.statusCode,
                      networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                          dioResponse: encryptedResponseFromServer,
                          apiRequestElapsedTime: elapsedTimeDuration,
                          decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                } else {
                  NetworkManagerUtils.getInstance().callCompletion("356457658553242",
                      responseBody: null,
                      success: false,
                      completion: requestCompletionCallback,
                      responseCompletionStatus: ResponseCompletionStatus.requestNullEmptyOrResponseCodeNotAvailable,
                      actualResponseCode: encryptedResponseFromServer.statusCode,
                      networkManagerLoggerHelperModel: NetworkManagerLoggerHelperModel(
                          dioResponse: encryptedResponseFromServer,
                          apiRequestElapsedTime: elapsedTimeDuration,
                          decryptedRequestBody: AppUtil.getEncodedJSONString(requestBody)));
                }
              } //else case ends for 403, 404, 410
            }).catchError((error, stackTrace) {
              AppUtil.showLog(LoggerConstants.dioLoggerKey, "OnError:::0000:::$error StackTrace:::$stackTrace");
              if (error != null && error.toString().toLowerCase().contains("Failed to parse header value".toLowerCase())) {
                //refresh the token
                //call the get gateway token
                //replace the token in the local app session
                //proceed, call the preceding API
                //which has been failed due to the gateway token expiry
                AppUtil.showLog(LoggerConstants.dioLoggerKey, "Error:::***HttpException: Failed to parse header value***");
                requestGenerateGateWayToken(completion: (bool success) {
                  if (success) {
                    AppUtil.showLog(LoggerConstants.dioLoggerKey, "Gateway Auth Token API Completed!");
                    callDioAPI(
                        isCommonPayloadRequired: false,
                        onForeground: onForeground,
                        requestMethod: RequestMethodConstants.post,
                        urlWithEndpoint: urlWithEndpoint,
                        requestHeaders: NetworkManagerUtils.getInstance().getRequestDefaultHeaders(),
                        requestBody: encryptedJSON,
                        isEncryptionDone: NetworkResponseKeysConstants.isEncryptionDone,
                        requestCompletionCallback: requestCompletionCallback);
                  } else {
                    AppUtil.showLog(LoggerConstants.dioLoggerKey, "Gateway Auth Token API Failed!");

                    ///any error from the Network Layer
                    NetworkManagerUtils.getInstance().callCompletion("890890890112333",
                        responseBody: null,
                        success: false,
                        completion: requestCompletionCallback,
                        responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                        actualResponseCode: 9999,
                        networkManagerFailureErrorLoggerHelperModel: NetworkManagerFailureErrorLoggerHelperModel(
                            urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
                  }
                });
              } else {
                NetworkManagerUtils.getInstance().callCompletion("908980912312908901",
                    responseBody: null,
                    success: false,
                    completion: requestCompletionCallback,
                    responseCompletionStatus: ResponseCompletionStatus.completedWithErrorOnNetworkLayer,
                    actualResponseCode: 9999,
                    networkManagerFailureErrorLoggerHelperModel: NetworkManagerFailureErrorLoggerHelperModel(
                        urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
              }
            });
          } on DioError catch (ex) {
            AppUtil.showLog(LoggerConstants.dioLoggerKey, "DioError:::1111:::${ex.message}");

            NetworkManagerUtils.getInstance().callCompletion("7564785234234234",
                responseBody: null,
                success: false,
                completion: requestCompletionCallback,
                responseCompletionStatus: ResponseCompletionStatus.completedWithDIOError,
                actualResponseCode: 9999,
                networkManagerFailureErrorLoggerHelperModel:
                    NetworkManagerFailureErrorLoggerHelperModel(urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
          }
        }
      } else {
        //no network
        NetworkManagerUtils.getInstance().callCompletion("6853452354234234",
            responseBody: null,
            success: false,
            completion: requestCompletionCallback,
            responseCompletionStatus: ResponseCompletionStatus.noInternetConnection,
            actualResponseCode: 9999,
            networkManagerFailureErrorLoggerHelperModel:
                NetworkManagerFailureErrorLoggerHelperModel(urlWithEndpoint: urlWithEndpoint, encryptedJSON: encryptedJSON ?? {}, requestHeaders: requestHeaders ?? {}));
      }
    });
  }
}
