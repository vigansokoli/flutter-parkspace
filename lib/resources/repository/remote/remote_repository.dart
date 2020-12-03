import 'dart:async';

import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/resources/repository/remote/api_endpoints.dart';
import 'package:parkspace/resources/repository/remote/api_provider.dart';

class RemoteRepository {
  final ApiProvider _apiProvider;

  static String errorKey = 'errors';

  RemoteRepository(this._apiProvider);

  void setToken(String token) {
    _apiProvider.setToken(token);
  }

  Future<dynamic> getRequest(String path, String responseKey) async {
    try {
      var response = await _apiProvider.get(path, responseKey);
      if (response != null) {
        if (response['error'] != null) return HttpError.fromJson(response);
        return responseKey.isEmpty ? response : response[responseKey];
      }
    } catch (error) {
      print('Error get events: $error');
      return HttpError.initError();
    }
  }

  Future<dynamic> postRequest(String path, String responseKey,
      [parameters]) async {
    try {
      var response = await _apiProvider.post(path, responseKey, parameters);
      if (response != null) {
        if (response['error'] != null) return HttpError.fromJson(response);
        return responseKey.isEmpty ? response : response[responseKey];
      }
    } catch (error) {
      print('Error get events: $error');
      return HttpError.initError();
    }
  }

  Future<dynamic> putRequest(String path, String responseKey,
      [parameters]) async {
    try {
      var response = await _apiProvider.put(path, responseKey, parameters);
      if (response != null) {
        if (response['error'] != null) return HttpError.fromJson(response);
        return responseKey.isEmpty ? response : response[responseKey];
      }
    } catch (error) {
      print('Error get events: $error');
      return HttpError.initError();
    }
  }

  //Auth
  Future<dynamic> login(Map<String, dynamic> data) async {
    return await postRequest(ApiEndpoints.login, '', data);
  }

  Future<dynamic> register(Map<String, dynamic> data) async {
    return await postRequest(ApiEndpoints.register, '', data);
  }

  Future<dynamic> resetPassword(Map<String, dynamic> data) async {
    return await postRequest(ApiEndpoints.resetPassword, '', data);
  }

  Future<dynamic> updateUser(Map<String, dynamic> data) async {
    return await putRequest(ApiEndpoints.updateUser, '', data);
  }

  //Spots
  Future<dynamic> getSpots() async {
    return await getRequest(ApiEndpoints.spots, '');
  }

  //Reservation
  Future<dynamic> createReservation(Map<String, dynamic> data) async {
    return await postRequest(ApiEndpoints.createReservation, '', data);
  }

  Future<dynamic> getActiveReservations() async {
    return await getRequest(ApiEndpoints.getActiveReservation, '');
  }

  Future<dynamic> getHistoryReservations() async {
    return await getRequest(ApiEndpoints.getHistoryReservation, '');
  }

  Future<dynamic> stopReservation(Map<String, dynamic> data) async {
    return await postRequest(ApiEndpoints.stopReservation, '', data);
  }
}
