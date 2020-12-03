import 'dart:async';

import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/data/Model/reservation.dart';
import 'package:parkspace/data/Model/spot.dart';
import 'package:parkspace/data/Model/user.dart';
import 'package:parkspace/resources/repository/remote/remote_repository.dart';
import 'package:parkspace/services/user_service.dart';

class ParkingService {
  RemoteRepository _remoteRepo;
  UserService _userService;

  List<Spot> spots;

  StreamController<Spot> selectedSpot = StreamController.broadcast();

  ParkingService(this._remoteRepo, this._userService);

  Future<HttpError> getSpots() async {
    var response = await _remoteRepo.getSpots();
    if (response is HttpError) {
      print('Error');
      return response;
    } else {
      var pSpots = Spot.parseList(response);
      if (pSpots != null) {
        spots = pSpots;
        return null;
      }
    }
    return HttpError.initError();
  }

  Future<HttpError> makeReservation(
      String spotId, String licensePlate, int hours, int minutes,
      {bool fullDay = false}) async {
    var data = {
      'spot': spotId,
      'licencePlate': licensePlate,
      'fullDay': fullDay,
      'duration': {
        'hours': hours,
        'minutes': minutes,
      },
    };

    var response = await _remoteRepo.createReservation(data);
    if (response is HttpError) {
      print('Error');
      return response;
    } else {
      var res = Reservation.fromJson(response);
      if (res != null) {
        var updatedUser = User.fromJson(response['user']);
        if (updatedUser != null) {
          _userService.setNewUser(updatedUser);
        }
        return null;
      }
    }
    return HttpError.initError();
  }

  Future<dynamic> getActiveReservations() async {
    var response = await _remoteRepo.getActiveReservations();
    if (response is HttpError) {
      print('Error');
      return response;
    } else {
      var reservations = Reservation.parseList(response);
      if (reservations != null) {
        return reservations;
      }
    }
    return HttpError.initError();
  }

  Future<dynamic> stopReservation(String id) async {
    var data = {'id': id};
    var response = await _remoteRepo.stopReservation(data);
    if (response is HttpError) {
      print('Error');
      return response;
    }
    var updatedUser = User.fromJson(response['user']);
    if (updatedUser != null) {
      _userService.setNewUser(updatedUser);
    }

    return null;
  }

  Future<dynamic> getHistoryReservations() async {
    var response = await _remoteRepo.getHistoryReservations();
    if (response is HttpError) {
      print('Error');
      return response;
    } else {
      var reservations = Reservation.parseList(response);
      if (reservations != null) {
        return reservations;
      }
    }
    return HttpError.initError();
  }

  void setSelectedSpot(Spot spot) {
    selectedSpot.add(spot);
  }
}
