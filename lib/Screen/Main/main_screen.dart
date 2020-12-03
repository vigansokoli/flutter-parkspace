import 'package:flutter/material.dart';
import 'package:parkspace/Components/shared_widgets.dart';
import 'package:parkspace/Screen/Menu/menu_screen.dart';
import 'package:parkspace/Screen/base_widget.dart';
import 'package:parkspace/app_router.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/viewmodels/main_screen_models/main_model.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import '../../theme/style.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  MainModel _model;

  TextEditingController _licensePlateController = TextEditingController();
  TextEditingController _sectorController = TextEditingController();

  bool _endOfDayActivation = false;
  var initialTime = DateTime.now();
  var _selectedTime;

  @override
  void initState() {
    initialTime = new DateTime(
      initialTime.year,
      initialTime.month,
      initialTime.day,
      0,
      0,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ParkingService parkingService = Provider.of<ParkingService>(context);
    UserService userService = Provider.of<UserService>(context);
    return BaseWidget<MainModel>(
        model:
            MainModel(parkingService: parkingService, userService: userService),
        onModelReady: (model) {
          _model = model;
        },
        builder: (context, model, child) {
          if (model.selectedSpot != null) {
            _sectorController.text = '${model.selectedSpot.sector}';
            // model.setSelectedSpot(null);
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: primaryColor,
              title: Text('ParkSpace'),
              actions: <Widget>[],
            ),
            key: _scaffoldKey,
            drawer: MenuScreens(activeScreenName: screenName),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _topInfoContainer(),
                    _selectedSectorInfo(),
                    _timeContainer(),
                    _endOfDayContainer(),
                    _parkingTimeContainer(),
                    _costsConainer(),
                    _startParkingContainer(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _topInfoContainer() {
    TextEditingController c = TextEditingController();
    return Container(
      // width: 100,
      height: 100,
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          wTextField(
              controller: _licensePlateController, hintText: 'License plate'),
          wTextField(
              controller: _sectorController,
              hintText: 'Sector',
              enabled: false),
          Container(
            width: 30,
            height: 30,
            child: InkWell(
              child: Image.asset('assets/image/gps.png'),
              onTap: () {
                print('Did tap google maps!');
                Navigator.of(context).pushNamed(AppRoute.mapScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeContainer() {
    return Container(
      height: 200,
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: TimePickerSpinner(
        time: initialTime,
        is24HourMode: true,
        normalTextStyle: TextStyle(fontSize: 21, color: Colors.grey),
        highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.black),
        minutesInterval: 15,
        spacing: 70,
        itemWidth: 60,
        itemHeight: 60,
        isForce2Digits: true,
        onTimeChange: (time) {
          setState(() {
            print('Selected Time: $time');
            _selectedTime = time;
            _endOfDayActivation = false;
            _model.hours = time.hour;
            _model.minutes = time.minute;
          });
        },
      ),
    );
  }

  Widget _endOfDayContainer() {
    return Container(
      height: 40,
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('End of day activation'),
            Checkbox(
                value: _endOfDayActivation,
                onChanged: (val) {
                  setState(() {
                    _endOfDayActivation = !_endOfDayActivation;
                    if (_endOfDayActivation && _model.selectedSpot != null) {
                      _model.calculateEndOfDayTime();
                    } else if (_selectedTime != null) {
                      _model.hours = _selectedTime.hour;
                      _model.minutes = _selectedTime.minute;
                    }
                  });
                })
          ],
        ),
      ),
    );
  }

  Widget _parkingTimeContainer() {
    return Container(
      height: 40,
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Parking time'),
            Text(_model.parseParkingTime()),
          ],
        ),
      ),
    );
  }

  Widget _costsConainer() {
    return Container(
      height: 80,
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('New balance'),
                ),
                Text(_model.getNewBalance(), style: TextStyle(fontSize: 22)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reserved amount',
                  ),
                ),
                Text(_model.calculateCosts(), style: TextStyle(fontSize: 22)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _startParkingContainer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('You only pay for the actual parking time!'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 200,
                height: 45,
                child: _model.isProcessing
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: primaryColor,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : FlatButton(
                        child: Text('START'),
                        color: primaryColor,
                        disabledColor: Colors.grey,
                        textColor: Colors.white,
                        disabledTextColor: Colors.white,
                        onPressed: _canMakeReservation() ? _startAction : null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedSectorInfo() {
    var spot = _model.selectedSpot;
    return Opacity(
      opacity: 0.7,
      child: spot != null
          ? Container(
              color: primaryColor,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 15, bottom: 10, top: 10),
                      child: Text(
                        'Selected Spot',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '${spot.name}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '${spot.startTime.toString()} - ${spot.endTime.toString()}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ]),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Max duration: ${spot.maxDuration.toString()}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Price per hour: ${spot.pricePerHour.toStringAsFixed(2)}€',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            )
          : Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: primaryColor,
              // padding: EdgeInsets.only(left: 15, bottom: 10, top: 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10, top: 10),
                child: Text(
                  'Please select the sector from the map first!',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
    );
  }

  bool _canMakeReservation() {
    if (_licensePlateController.text.isEmpty ||
        _model.selectedSpot == null ||
        _model.newBalance.isNegative) return false;
    return _model.validateReservation();
  }

  Future<void> _startAction() async {
    print('did tap button');
    if (_licensePlateController.text.isEmpty) {
      var dialog = AppDialog(
          message: 'Please type license plate!', firstButtonText: 'Ok');
      defaultDialog(dialog: dialog, context: context);
    } else {
      var success = await _model.makeReservation(
          _licensePlateController.text, _endOfDayActivation);
      if (success) {
        print('Success');
        resetData();
        Navigator.of(context).pushNamed(AppRoute.activeReservations);
      } else {
        defaultDialog(dialog: _model.error, context: context);
      }
    }
  }

  void resetData() {
    setState(() {
      _licensePlateController.text = '';
      _model.setSelectedSpot(null);
      _sectorController.text = '';
      _selectedTime = initialTime;
      _model.hours = 0;
      _model.minutes = 0;
    });
  }

  Widget wTextField(
      {@required TextEditingController controller,
      @required String hintText,
      bool enabled = true}) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        enabled: enabled,
        decoration: InputDecoration(
          focusColor: Colors.white,
          labelText: hintText,
          labelStyle:
              TextStyle(color: Colors.white, decoration: TextDecoration.none),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid)),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid)),
          contentPadding: EdgeInsets.all(
            2.0,
          ),
        ),
        onSubmitted: (value) {},
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.text,
        keyboardAppearance: Brightness.dark,
        autocorrect: false,
        // cursorColor: Colors.black,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
