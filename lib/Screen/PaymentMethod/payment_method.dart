import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parkspace/Components/shared_widgets.dart';
import 'package:parkspace/Screen/Menu/menu_screen.dart';
import 'package:parkspace/Screen/PaymentMethod/paypal_payment_screen.dart';
import 'package:parkspace/Screen/base_widget.dart';
import 'package:parkspace/app_router.dart';
import 'package:parkspace/data/Model/balance_pack.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/services/paypal_service.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/theme/style.dart';
import 'package:parkspace/viewmodels/payment_models/paypal_model.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final String screenName = "PAYMENT";
  PaypalServices services;
  bool successfullyUpdateBalance = false;

  List<Pack> listOfPacks = [
    Pack(
        id: '0',
        title: '5€',
        description: 'Increase your balance with 5€.',
        price: 5),
    Pack(
        id: '1',
        title: '10€',
        description: 'Increase your balance with 10€.',
        price: 10),
    Pack(
        id: '2',
        title: '20€',
        description: 'Increase your balance with 20€.',
        price: 20),
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    services = Provider.of<PaypalServices>(context);
    UserService userService = Provider.of<UserService>(context);

    return BaseWidget<PaypalModel>(
        model: PaypalModel(paypalServices: services, userService: userService),
        onModelReady: (model) {
          // _model = model;
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Payment method',
                style: TextStyle(color: blackColor),
              ),
              backgroundColor: whiteColor,
              elevation: 2.0,
              iconTheme: IconThemeData(color: blackColor),
            ),
            drawer: MenuScreens(activeScreenName: screenName),
            body: Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Text(
                      'Select pack',
                      style: textStyle,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemCount: listOfPacks.length,
                        shrinkWrap: false,
                        separatorBuilder: (_, int i) {
                          return Divider(
                            height: 2,
                          );
                        },
                        itemBuilder: (BuildContext context, index) {
                          return packCell(context, listOfPacks[index]);
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget packCell(BuildContext context, Pack pack) {
    return GestureDetector(
      onTap: () {
        services.selectedBalancePack = pack;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context2) => PaypalPayment(
              onFinish: (success) async {
                // payment done
                if (success) {
                  successfullyUpdateBalance = success;
                  Future.delayed(
                      Duration(
                        seconds: 1,
                      ), () {
                    _showAlert(context);
                  });
                }
              },
            ),
          ),
        );
      },
      child: Container(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color(0x88999999),
            offset: Offset(0, 5),
            blurRadius: 5.0,
          ),
        ]),
        child: Row(
          children: <Widget>[
            Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: greyColor2,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Image.asset(
                  "assets/image/image_paypal.png",
                  height: 45.0,
                )),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      pack.title,
                      style: TextStyle(
                        color: const Color(0XFF000000),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "OpenSans",
                      ),
                    ),
                    Text(pack.description,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: "OpenSans",
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.arrow_forward_ios,
                color: blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    if (successfullyUpdateBalance) {
      print('Successsss!!');
      successfullyUpdateBalance = false;
      var appDialog = AppDialog(
        title: 'Balance update',
        message:
            'You successfully added €${services.selectedBalancePack.price.toStringAsPrecision(2)} to your balance.',
        firstButtonText: 'Ok',
      );
      defaultDialog(dialog: appDialog, context: context);
    }
  }
}
