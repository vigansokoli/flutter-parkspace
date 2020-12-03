import 'dart:core';
import 'package:flutter/material.dart';
import 'package:parkspace/Components/shared_widgets.dart';
import 'package:parkspace/Screen/base_widget.dart';
import 'package:parkspace/data/Model/balance_pack.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/services/paypal_service.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/viewmodels/payment_models/paypal_model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  PaypalPayment({this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  PaypalModel _model;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  // PaypalServices services;

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "€ ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "EUR"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await _model.getAccessToken();

        final transactions = getOrderParams();
        final res = await _model.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  // String itemName = 'Parking balance';
  // String itemPrice = '5.00';
  // int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    Pack selectedPack = _model.selectedPack();
    List items = [
      {
        "name": selectedPack.title,
        "quantity": 1,
        "price": selectedPack.price,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = '${_model.selectedPack().price.toStringAsFixed(2)}';
    String subTotalAmount = '${_model.selectedPack().price.toStringAsFixed(2)}';
    // String shippingCost = '0';
    // int shippingDiscountCost = 0;
    // String userFirstName = 'Test';
    // String userLastName = 'User';
    // String addressCity = 'Thessaloniki';
    // String addressStreet = 'Test Street';
    // String addressZipCode = '10014';
    // String addressCountry = 'Greece';
    // String addressState = 'Greece';
    // String addressPhoneNumber = '+123456789';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              // "shipping": shippingCost,
              // "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": _model.selectedPack().description,
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            // if (isEnableShipping && isEnableAddress)
            //   "shipping_address": {
            //     "recipient_name": userFirstName + " " + userLastName,
            //     "line1": addressStreet,
            //     "line2": "",
            //     "city": addressCity,
            //     "country_code": addressCountry,
            //     "postal_code": addressZipCode,
            //     "phone": addressPhoneNumber,
            //     "state": addressState
            //   },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);
    PaypalServices paypalServices = Provider.of<PaypalServices>(context);
    UserService userService = Provider.of<UserService>(context);
    return BaseWidget<PaypalModel>(
        model: PaypalModel(
            paypalServices: paypalServices, userService: userService),
        onModelReady: (model) {
          _model = model;
        },
        builder: (context, model, child) {
          if (checkoutUrl != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              body: WebView(
                initialUrl: checkoutUrl,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.contains(returnURL)) {
                    final uri = Uri.parse(request.url);
                    final payerID = uri.queryParameters['PayerID'];
                    if (payerID != null) {
                      model
                          .executePayment(executeUrl, payerID, accessToken)
                          .then((success) {
                        widget.onFinish(success);
                        if (!success) {
                          defaultDialog(dialog: model.error, context: context);
                        }
                      });
                    }
                    // else {
                    //   Navigator.of(context).pop();
                    // }
                    Navigator.of(context).pop();
                  }
                  if (request.url.contains(cancelURL)) {
                    Navigator.of(context).pop();
                  }
                  return NavigationDecision.navigate;
                },
              ),
            );
          } else {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                backgroundColor: Colors.black12,
                elevation: 0.0,
              ),
              body:
                  Center(child: Container(child: CircularProgressIndicator())),
            );
          }
        });
  }
}
