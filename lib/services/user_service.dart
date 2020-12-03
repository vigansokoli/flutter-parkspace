import 'dart:async';
import 'dart:convert';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/data/Model/user.dart';
import 'package:parkspace/resources/repository/remote/remote_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final RemoteRepository _remoteRepo;

  StreamController<User> userController = StreamController.broadcast();
  User _user;
  User get user => _user;

  static String userDataKey = 'UserKey2';

  UserService(this._remoteRepo) {
    initLocalUser();
  }

  Future<HttpError> login(String email, String password) async {
    String udid = await FlutterUdid.udid;

    var data = {'email': email, 'password': password, 'deviceId': udid};

    var response = await _remoteRepo.login(data);
    if (response is HttpError) {
      print('Error');
      return response;
    } else {
      var rUser = User.fromJson(response);
      if (rUser != null) {
        setNewUser(rUser);
        return null;
      }
    }
    return HttpError.initError();
  }

  Future<HttpError> register(String email, String password) async {
    String udid = await FlutterUdid.udid;
    var data = {'email': email, 'password': password, 'deviceId': udid};

    var response = await _remoteRepo.register(data);
    if (response is HttpError) {
      print('Error');
      return response;
    } else {
      var rUser = User.fromJson(response);

      if (rUser != null) {
        setNewUser(rUser);
        return null;
      }
    }
    return HttpError.initError();
  }

  Future<HttpError> updateBalance(int addedBalance) async {
    _user.balance += addedBalance;
    saveLocalUser(_user);
    var userData = _user.toJson();
    print('User json: $userData');
    var response = await _remoteRepo.updateUser(userData);

    if (response is HttpError) {
      print('Error');
      return response;
    }

    return null;
  }

  void setNewUser(User user) {
    _user = user;
    userController.add(user);
    _remoteRepo.setToken(user.token);
    saveLocalUser(user);
  }

  Future<HttpError> resetPassword(String email) async {
    var data = {'email': email};

    var response = await _remoteRepo.resetPassword(data);
    if (response is HttpError) {
      print('Error');
      return response;
    }
    return null;
  }

  void removeLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userDataKey);
  }

  void saveLocalUser(User user) async {
    String userEncoded = jsonEncode(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userDataKey, userEncoded);
  }

  void initLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get(userDataKey);

    if (data == null) return null;
    Map<String, dynamic> user = jsonDecode(data);
    _user = User.fromJson(user);
    _remoteRepo.setToken(_user.token);
  }
}
