import 'package:dio/dio.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/interfaces/http_client.dart';
import 'package:parkspace/resources/repository/remote/api_endpoints.dart';

class DioHttpClient implements IHttpClient {
  Dio _dio;
  DioHttpClient() {
    _dio = new Dio(new BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 10000,
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
      headers: {},
      // contentType: ContentType.json,
    ));
  }

  @override
  Future<Map<String, dynamic>> get(String url) async {
    try {
      var resp = await _dio.get(url);
      if (resp.statusCode == 422)
        return HttpError.responseErrorDio(resp).toJson();
      if (resp.statusCode == 498) return HttpError.invalidTokenError().toJson();
      if (resp.statusCode == 504) return HttpError.initError().toJson();
      return resp.data;
    } on DioError catch (e) {
      if (e.response != null && e.response.data['error'] != null) {
        return HttpError.dioError(e).toJson();
      }
    }
    return new Map<String, dynamic>();
  }

  @override
  Future<Map<String, dynamic>> post(String url, [parameters]) async {
    try {
      var resp = await _dio.post(url, data: parameters);
      if (resp.statusCode == 422)
        return HttpError.responseErrorDio(resp).toJson();
      if (resp.statusCode == 498) return HttpError.invalidTokenError().toJson();
      if (resp.statusCode == 504) return HttpError.initError().toJson();
      return resp.data;
    } on DioError catch (e) {
      if (e.response != null && e.response.data['error'] != null) {
        return HttpError.dioError(e).toJson();
      }
    }
    return new Map<String, dynamic>();
  }

  @override
  Future<Map<String, dynamic>> put(String url, [parameters]) async {
    try {
      var resp = await _dio.put(url, data: parameters);
      if (resp.statusCode == 422)
        return HttpError.responseErrorDio(resp).toJson();
      if (resp.statusCode == 498) return HttpError.invalidTokenError().toJson();
      if (resp.statusCode == 504) return HttpError.initError().toJson();
      return resp.data;
    } on DioError catch (e) {
      if (e.response != null && e.response.data['error'] != null) {
        return HttpError.dioError(e).toJson();
      }
    }
    return new Map<String, dynamic>();
  }

  @override
  void setToken(String token) {
    print('set token: $token');
    _dio.options.headers['Authorization'] = "Bearer $token";
  }
}
