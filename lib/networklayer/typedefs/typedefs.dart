import 'package:flutter_utils_juni1289/apputil/enums_util_helper.dart';

///completion callback, that is when the api is completed will get called
typedef RequestCompletionCallback = void Function({required String requestResponse, required bool success, required RequestCompletionStatusEnums responseCompletionStatus});
