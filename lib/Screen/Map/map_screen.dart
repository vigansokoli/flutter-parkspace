import 'package:flutter/material.dart';
import 'package:parkspace/services/parking_service.dart';
import 'package:parkspace/viewmodels/map_screen_models/google_map_model.dart';
import 'package:provider/provider.dart';

import 'map_view.dart';

class MapScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parkingService = Provider.of<ParkingService>(context);
    var mapModel = GoogleMapModel(parkingService: parkingService);
    return MapView(
      mapModel: mapModel,
    );
  }
}
