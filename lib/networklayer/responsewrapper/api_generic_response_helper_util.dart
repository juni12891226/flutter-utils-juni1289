import 'package:flutter_utils_juni1289/networklayer/responsewrapper/generics_util.dart';
import 'package:flutter_utils_juni1289/networklayer/typedefs/typedefs.dart';

class APIObjectTypeResponse<T> extends GenericObject<T> implements Decodable<APIObjectTypeResponse<T>> {
  String? responseCode;
  String? responseMessage;
  String? status;
  T? data;

  APIObjectTypeResponse({CreateModelClassCallback<Decodable>? create}) : super(create: create);

  @override
  APIObjectTypeResponse<T> decode(dynamic json) {
    responseCode = (json['code'] ?? '-1').toString();
    responseMessage = json['message'] ?? '';
    status = json['status'] ?? '';

    data = (json as Map<String, dynamic>).containsKey('data')
        ? json['data'] == null
            ? null
            : genericObject(json['data'])
        : null;
    return this;
  }
}

class APIListTypeResponse<T> extends GenericObject<T> implements Decodable<APIListTypeResponse<T>> {
  String? responseCode;
  String? responseMessage;
  String? status;
  List<T>? data;

  APIListTypeResponse({CreateModelClassCallback<Decodable>? create}) : super(create: create);

  @override
  APIListTypeResponse<T> decode(dynamic json) {
    responseCode = json['responseCode'] ?? "";
    responseMessage = json['responseMessage'] ?? "";
    status = json['status'] ?? '';
    data = [];
    if ((json as Map<String, dynamic>).containsKey('data') && json["data"] != null) {
      json['data'].forEach((item) {
        data!.add(genericObject(item));
      });
    }

    return this;
  }
}

class ErrorResponse implements Exception {
  String? message;

  ErrorResponse({this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(message: json['responseMessage'] ?? "Response Wrapper Error.");
  }

  @override
  String toString() {
    return message!;
  }
}
