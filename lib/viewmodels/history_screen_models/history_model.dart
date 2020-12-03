import 'package:flutter/material.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/data/Model/reservation.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/viewmodels/base_model.dart';

class HistoryModel extends BaseModel {
  ParkingService _parkingService;
  List<Reservation> reservations = List<Reservation>();

  HistoryModel({@required ParkingService parkingService}) {
    _parkingService = parkingService;
  }

  Future<bool> getHistoryReservations() async {
    reservations = List<Reservation>();
    setProcessing(true);
    var response = await _parkingService.getHistoryReservations();
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Okay",
      );
    } else if (response is List<Reservation>) reservations = response;
    setProcessing(false);
    return response is! HttpError;
  }

  @override
  void dispose() {
    print("MAIN MODEL DISPOSE");
    super.dispose();
  }
}
