import 'package:flutter_utils_juni1289/networklayer/responsewrapper/api_generic_response_helper_util.dart';
import 'package:flutter_utils_juni1289/networklayer/responsewrapper/generics_util.dart';
import 'package:flutter_utils_juni1289/networklayer/typedefs/typedefs.dart';

class ResponseWrapper<T> extends GenericObject<T> {
  T? response;
  ErrorResponse? error;

  ResponseWrapper({CreateModelClassCallback<Decodable>? create, this.error}) : super(create: create);

  factory ResponseWrapper.init({CreateModelClassCallback<Decodable>? create, Map<String, dynamic>? json}) {
    final wrapper = ResponseWrapper<T>(create: create);
    wrapper.response = wrapper.genericObject(json);

    if (wrapper.response is APIObjectTypeResponse) {
      var finalResponse = wrapper.response as APIObjectTypeResponse;
      if (finalResponse.responseCode != '00') {
        wrapper.error = ErrorResponse.fromJson(json!);
      }
    }
    return wrapper;
  }
}
