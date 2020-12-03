import 'dart:async';

import 'package:parkspace/data/Model/http_clients/dio_http_client.dart';
import 'package:parkspace/interfaces/http_client.dart';

class ApiProvider {
  String _token = '';
  IHttpClient _httpClient;

  ApiProvider() {
    _httpClient = new DioHttpClient();
  }

  String get token => _token;

  void setToken(String token) {
    print('Token: $token');
    _token = token;
    _httpClient.setToken(token);
  }

  Future<Map<String, dynamic>> get(
    String path,
    String responseKey,
  ) async {
    return _httpClient.get(path);
  }

  Future<Map<String, dynamic>> post(String path, String responseKey,
      [parameters]) async {
    return _httpClient.post(path, parameters);
  }

    Future<Map<String, dynamic>> put(String path, String responseKey,
      [parameters]) async {
    return _httpClient.put(path, parameters);
  }

}
