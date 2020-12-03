import 'package:flutter/cupertino.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/data/Model/errors/http_error.dart';
import 'package:parkspace/data/Model/spot.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/viewmodels/base_model.dart';

class GoogleMapModel extends BaseModel {
  ParkingService _parkingService;

  Spot selectedSpot;
  List<Spot> spots() => _parkingService.spots;

  GoogleMapModel({@required ParkingService parkingService}) {
    _parkingService = parkingService;
  }

  void setSelectedSpot(Spot spot) {
    _parkingService.setSelectedSpot(spot);
  }

  Future<bool> getSpots() async {
    setProcessing(true);
    var response = await _parkingService.getSpots();
    if (response is HttpError) {
      this.errorDialog = AppDialog(
        message: response.message,
        firstButtonText: "Ok",
      );
    }
    
    setProcessing(false);
    return response == null;
  }

  void markerTapped(String id) {
    Spot s = spots().firstWhere((element) => element.id == id);
    if (s != null) {
      selectedSpot = s;
      setSelectedSpot(s);
    }
  }

  @override
  void dispose() {
    print("MAIN MODEL DISPOSE");
    super.dispose();
  }
}
