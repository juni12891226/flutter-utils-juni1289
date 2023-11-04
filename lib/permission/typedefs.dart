import 'package:flutter_utils_juni1289/networklayer/enums/request_completion_status_enums.dart';

///completion callback, that is when the api is completed will get called
typedef RequestCompletionCallback = void Function(String requestResponse, bool success, RequestCompletionStatusEnums responseCompletionStatus);
