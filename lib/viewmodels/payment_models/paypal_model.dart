import 'package:flutter/material.dart';
import 'package:parkspace/data/Model/balance_pack.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/services/paypal_service.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/viewmodels/base_model.dart';

class PaypalModel extends BaseModel {
  PaypalServices _paypalServices;
  UserService _userService;

  Pack selectedPack() => _paypalServices.selectedBalancePack;

  PaypalModel(
      {@required PaypalServices paypalServices,
      @required UserService userService}) {
    _paypalServices = paypalServices;
    _userService = userService;
  }

  Future<String> getAccessToken() async => _paypalServices.getAccessToken();

  Future<Map<String, String>> createPaypalPayment(
          transactions, accessToken) async =>
      _paypalServices.createPaypalPayment(transactions, accessToken);

  Future<bool> executePayment(executeUrl, payerID, accessToken) async {
    var response =
        _paypalServices.executePayment(executeUrl, payerID, accessToken);
    if (response != null) {
      var updateBalanceResponse = await _userService
          .updateBalance(_paypalServices.selectedBalancePack.price);
      if (updateBalanceResponse is HttpError) {
        this.errorDialog = AppDialog(
          message: updateBalanceResponse.message,
          firstButtonText: "Okay",
        );
        return false;
      } else {  
        _paypalServices.successfullyUpdatedBalance = true;
      }
    } else return false;

    return true;
  }

  @override
  void dispose() {
    print("MAIN MODEL DISPOSE");
    super.dispose();
  }
}
