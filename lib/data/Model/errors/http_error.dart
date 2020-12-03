import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HttpError {
  final String error;
  final String message;
  final int statusCode;
  DioErrorType type;

  HttpError({
    @required this.error,
    @required this.message,
    @required this.statusCode,
    this.type = DioErrorType.DEFAULT,
  });

  factory HttpError.initError() {
    return HttpError(
      error: "Response",
      message:
          "Looks like the server is taking to long to respond, this can be caused by either poor connectivity or an error with our servers. Please try again in a while!",
      statusCode: 422,
    );
  }

  factory HttpError.invalidTokenError() {
    return HttpError(
      error: "Response",
      message: "Invalid Token!",
      statusCode: 498,
    );
  }

  factory HttpError.responseErrorDio(Response<dynamic> resp) {
    return HttpError(
      error: "Response",
      message: resp.data['error']['message'],
      statusCode: resp.statusCode,
    );
  }

  factory HttpError.responseErrorHttp(http.Response resp) {
    var data = json.decode(resp.body);
    return HttpError(
      error: "Response",
      message: data['error']['message'],
      statusCode: resp.statusCode,
    );
  }

  factory HttpError.dioError(DioError e) {
    return HttpError(
      error: "Dio",
      message: e.response.data['error']['message'],
      statusCode: e.response.statusCode,
      type: e.type,
    );
  }

  HttpError.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        message = json['error'],
        statusCode = json['statusCode'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'statusCode': statusCode,
        'type': type,
      };
}
