import 'package:flutter/material.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/data/Model/spot.dart';
import 'package:parkspace/enums/viewstate.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/viewmodels/base_model.dart';

class MainModel extends BaseModel {
  UserService _userService;
  ParkingService _parkingService;

  Spot selectedSpot;

  var hours = 0;
  var minutes = 0;
  var cost = 0.0;
  var newBalance = 0.0;
  var endOfDay = false;

  MainModel(
      {@required ParkingService parkingService,
      @required UserService userService}) {
    _parkingService = parkingService;
    _userService = userService;
    newBalance = _userService.user.balance;
    
    _parkingService.selectedSpot.stream.listen((spot) {
      selectedSpot = spot;
      notifyListeners();
      setState(ViewState.Idle);
    });
  }

  void setSelectedSpot(Spot spot) {
    _parkingService.setSelectedSpot(spot);
  }

  String parseParkingTime() {
    if ((hours == 0 && minutes == 0) || selectedSpot == null) return '';

    if (!checkIfSelectedTimeExceedsMaxDuration()) {
      hours = selectedSpot.maxDuration.hours;
      minutes = selectedSpot.maxDuration.minutes;
    } else if (!checkIfSelectedTimeExceedsEndTime()) {
      var now = DateTime.now();

      var endOfDay = DateTime(
        now.year,
        now.month,
        now.day,
        selectedSpot.endTime.hours,
        selectedSpot.endTime.minutes,
      );

      var diff = endOfDay.difference(now);
      if (diff.isNegative) {
        hours = 0;
        minutes = 0;
      } else {
        hours = diff.inHours;
        minutes = (diff.inMinutes % 60) - 1;
      }
    }

    var h = hours < 10 ? '0$hours' : '$hours';
    var m = minutes < 10 ? '0$minutes' : '$minutes';

    calculateCosts();
    getNewBalance();

    return '${h}h:${m}m';
  }

  void calculateEndOfDayTime() {
    if (selectedSpot == null) return;

    var now = DateTime.now();
    var endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      selectedSpot.endTime.hours,
      selectedSpot.endTime.minutes,
    );

    var diff = endOfDay.difference(now);
    if (diff.isNegative) {
      hours = 0;
      minutes = 0;
      return;
    }
    hours = diff.inHours;
    minutes = (diff.inMinutes % 60) - 1;
  }

  String calculateCosts() {
    if ((hours == 0 && minutes == 0) || selectedSpot == null) return '';

    var pricePerHour = selectedSpot.pricePerHour;
    cost = (hours * pricePerHour + (pricePerHour / 60.0) * minutes);
    if (_userService.user.balance - cost < 0.0) {
      cost = _userService.user.balance;
      hours = cost ~/ pricePerHour;
      var minutesCost = cost % pricePerHour;
      minutes = minutesCost ~/ (pricePerHour / 60.0);
    }
    newBalance = _userService.user.balance - cost;

    if (cost == 0) return '';

    return '€ ${cost.toStringAsFixed(2)}';
  }

  String getNewBalance() {
    return '€ ${newBalance.toStringAsFixed(2)}';
  }

  bool validateReservation() {
    return checkIfSelectedTimeExceedsEndTime() &&
        checkIfSelectedTimeExceedsMaxDuration();
  }

  bool checkIfSelectedTimeExceedsEndTime() {
    var now = DateTime.now();

    var selectedTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + hours,
      now.minute + minutes,
    );

    var endTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedSpot.endTime.hours,
      selectedSpot.endTime.minutes,
    );

    var diff = endTime.difference(selectedTime);
    return !diff.isNegative;
  }

  bool checkIfSelectedTimeExceedsMaxDuration() {
    if ((hours + minutes / 100.0) >
        (selectedSpot.maxDuration.hours +
            selectedSpot.maxDuration.minutes / 100.0)) return false;
    return true;
  }

  Future<bool> makeReservation(String licensePlate, bool fullDay) async {
    setProcessing(true);
    if (newBalance.isNegative) return false;

    var response = await _parkingService.makeReservation(
      selectedSpot.id,
      licensePlate,
      hours,
      minutes,
      fullDay: fullDay,
    );

    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Okay",
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
