import 'package:flutter/material.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/viewmodels/base_model.dart';

class AuthModel extends BaseModel {
  UserService _userService;

  AuthModel({@required UserService userService}) {
    _userService = userService;
    print('parking S: $_userService');
  }

  Future<bool> login(String email, String password) async {
    setProcessing(true);
    var response = await _userService.login(email, password);
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Ok",
      );
    }

    setProcessing(false);
    return response == null;
  }

  Future<bool> register(String email, String password) async {
    setProcessing(true);
    var response = await _userService.register(email, password);
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Ok",
      );
    }

    setProcessing(false);
    return response == null;
  }

  Future<bool> resetPassword(String email) async {
    setProcessing(true);
    var response = await _userService.resetPassword(email);
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Ok",
      );
    }

    setProcessing(false);
    return response == null;
  }

  @override
  void dispose() {
    print("MAIN MODEL DISPOSE");
    super.dispose();
  }
}
