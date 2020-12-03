import 'package:flutter/material.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/data/Model/reservation.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/viewmodels/base_model.dart';

class ReservationsModel extends BaseModel {
  ParkingService _parkingService;

  List<Reservation> reservations = List<Reservation>();

  ReservationsModel({@required ParkingService parkingService}) {
    _parkingService = parkingService;
  }

  Future<bool> getActiveReservations() async {
    reservations = List<Reservation>();
    setProcessing(true);
    var response = await _parkingService.getActiveReservations();
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Ok",
      );
    }

    if (response is List<Reservation>) reservations = response;
    setProcessing(false);
    return response is! HttpError;
  }

  Future<bool> stopReservation(String id) async {
    setProcessing(true);
    var response = await _parkingService.stopReservation(id);
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Ok",
      );
    } else {
      getActiveReservations();
    }

    return response is! HttpError;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
