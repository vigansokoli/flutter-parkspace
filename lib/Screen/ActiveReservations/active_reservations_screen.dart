import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:parkspace/Components/animation_list_view.dart';
import 'package:parkspace/Components/shared_widgets.dart';
import 'package:parkspace/Screen/base_widget.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/reservation.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/Screen/Menu/menu_screen.dart';
import 'package:parkspace/theme/style.dart';
import 'package:parkspace/viewmodels/active_reservations_models/reservations_model.dart';
import 'package:provider/provider.dart';

class ActiveReservationScreen extends StatefulWidget {
  @override
  _ActiveReservationScreenState createState() =>
      _ActiveReservationScreenState();
}

class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
  final String screenName = "ACTIVE";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  ReservationsModel _model;

  @override
  Widget build(BuildContext context) {
    ParkingService parkingService = Provider.of<ParkingService>(context);
    return BaseWidget<ReservationsModel>(
      model: ReservationsModel(parkingService: parkingService),
      onModelReady: (model) async {
        _model = model;
        var success = await model.getActiveReservations();
        if (!success) {
          defaultDialog(dialog: model.error, context: context);
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: primaryColor,
            title: Text('ParkSpace'),
            // actions: <Widget>[],
          ),
          backgroundColor: Colors.grey[100],
          key: _scaffoldKey,
          drawer: MenuScreens(activeScreenName: screenName),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return false;
            },
            child: model.isProcessing
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: primaryColor,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : ListView.separated(
                    itemCount: model.reservations.length + 1,
                    shrinkWrap: false,
                    separatorBuilder: (_, int i) {
                      return Divider(
                        height: 1,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: <Widget>[
                            _header(),
                            // _itemCell(model.reservations[index]),
                          ],
                        );
                      } else {
                        return _itemCell(model.reservations[index - 1]);
                      }
                    }),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Opacity(
      opacity: 0.7,
      child: Container(
        height: 60,
        color: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: AutoSizeText(
                'License plate',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: AutoSizeText(
                'Sector',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: AutoSizeText(
                'End',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
            )
          ],
        ),
      ),
    );
  }

  Widget _itemCell(Reservation reservation) {
    return Container(
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: AutoSizeText(
              reservation.licencePlate,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: AutoSizeText(
              '${reservation.spot.sector}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: AutoSizeText(
                      reservation.getReservationDate(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: AutoSizeText(
                      reservation.getReservationEndTime(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 80,
            child: FlatButton(
                child: AutoSizeText(
                  'STOP',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                color: Colors.yellow,
                textColor: Colors.white,
                onPressed: () {
                  var appDialog = AppDialog(
                      title: 'Stop parking?',
                      message: '',
                      secondButtonText: 'Stop',
                      firstButtonText: 'Cancel',
                      secondButtonOnPressed: () {
                        Navigator.pop(context);
                        _stopReservation(reservation.id);
                      },
                      firstButtonOnPressed: () {
                        Navigator.pop(context);
                      });
                  defaultDialog(dialog: appDialog, context: context);
                }),
          )
        ],
      ),
    );
  }

  void _stopReservation(String id) async {
    var success = await _model.stopReservation(id);
    // setState(() {
    if (!success) {
      defaultDialog(dialog: _model.error, context: context);
    }
    // });
  }
}
