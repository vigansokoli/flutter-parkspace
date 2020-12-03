import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:parkspace/Components/shared_widgets.dart';
import 'package:parkspace/data/Model/map_type_model.dart';
import 'package:parkspace/data/Model/spot.dart';
import 'package:parkspace/theme/style.dart';
import 'package:parkspace/viewmodels/map_screen_models/google_map_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'select_map_type.dart';

class MapView extends StatefulWidget {
  final GoogleMapModel mapModel;
  MapView({this.mapModel});
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Set<Marker> _markers = Set<Marker>();

  GoogleMapController _mapController;
  GoogleMapController mapController;
  // CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = new List<MapTypeModel>();
  PersistentBottomSheetController _controller;

  Position currentLocation;
  Position _lastKnownPosition;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  bool isEnabledLocation = false;

  Marker selectedMarker;

  @override
  void initState() {
    super.initState();
//    _initLastKnownLocation();
//    _initCurrentLocation();
    fetchLocation();
    showPersBottomSheetCallBack = _showBottomSheet;
    sampleData.add(MapTypeModel(1, true, 'assets/style/maptype_nomal.png',
        'Nomal', 'assets/style/nomal_mode.json'));
    sampleData.add(MapTypeModel(2, false, 'assets/style/maptype_silver.png',
        'Silver', 'assets/style/sliver_mode.json'));
    sampleData.add(MapTypeModel(3, false, 'assets/style/maptype_dark.png',
        'Dark', 'assets/style/dark_mode.json'));
    sampleData.add(MapTypeModel(4, false, 'assets/style/maptype_night.png',
        'Night', 'assets/style/night_mode.json'));
    sampleData.add(MapTypeModel(5, false, 'assets/style/maptype_netro.png',
        'Netro', 'assets/style/netro_mode.json'));
    sampleData.add(MapTypeModel(6, false, 'assets/style/maptype_aubergine.png',
        'Aubergine', 'assets/style/aubergine_mode.json'));
  }

  ///Get last known location
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator?.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {
      return;
    }
    _lastKnownPosition = position;
  }

  Future<void> checkPermission() async {
    isEnabledLocation = await Permission.location.serviceStatus.isEnabled;
  }

  void fetchLocation() {
    checkPermission()?.then((_) {
      if (isEnabledLocation) {
        _initCurrentLocation();
      }
    });
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (currentLocation != null) {
      moveCameraToMyLocation();
    }
  }

  void moveCameraToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    Future.delayed(Duration(seconds: 1), () async {
      // _getMarkers();
      var success = await widget.mapModel.getSpots();
      if (!success) {
        defaultDialog(dialog: widget.mapModel.error, context: context);
      } else {
        setState(() {
          _setupMarkers();
        });
      }
    });
  }

  void _setupMarkers() {
    for (var spot in widget.mapModel.spots()) {
      var id = MarkerId(spot.id);
      var marker = Marker(
          markerId: id,
          position: LatLng(spot.lat, spot.lng),
          onTap: () {
            setState(() {
              widget.mapModel.markerTapped(id.value);
            });
          });
      _markers.add(marker);
    }
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName) {
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }

  void _showBottomSheet() async {
    setState(() {
      showPersBottomSheetCallBack = null;
    });
    _controller = _scaffoldKey.currentState.showBottomSheet((context) {
      return new Container(
          height: 300.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Map type",
                        style: heading18Black,
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: blackColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: new GridView.builder(
                    itemCount: sampleData.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        highlightColor: Colors.red,
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          _closeModalBottomSheet();
                          sampleData
                              .forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;
                          changeMapType(
                              sampleData[index].id, sampleData[index].fileName);
                        },
                        child: new SelectMapTypeView(sampleData[index]),
                      );
                    },
                  ),
                )
              ],
            ),
          ));
    });
  }

  Widget _markerInfo() {
    Spot spot = widget.mapModel.selectedSpot;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('SectorId: ${spot.sector}'),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${spot.name}'),
                Text(
                    '${spot.startTime.toString()} - ${spot.endTime.toString()}'),
                Text('Max duration: ${spot.maxDuration.toString()}'),
                Text(
                    'Price per hour: ${spot.pricePerHour.toStringAsFixed(2)}€'),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 160,
            height: 45,
            child: FlatButton(
                child: Text('OK'),
                color: primaryColor,
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ),
      ],
    );
  }

  void _closeModalBottomSheet() {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SizedBox(
            child: GoogleMap(
              markers: _markers,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation != null
                        ? currentLocation?.latitude
                        : _lastKnownPosition?.latitude ?? 42.659992,
                    currentLocation != null
                        ? currentLocation?.longitude
                        : _lastKnownPosition?.longitude ?? 21.166987),
                zoom: 12.0,
              ),
              onCameraMove: (CameraPosition position) {},
            ),
          ),
          widget.mapModel.selectedSpot != null
              ? Positioned(
                  bottom: 30.0,
                  left: 20.0,
                  right: 20.0,
                  child: Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(color: Colors.grey)),
                    child: _markerInfo(),
                  ),
                )
              : SizedBox(),
          Positioned(
              top: 120,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  fetchLocation();
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Icon(
                    Icons.my_location,
                    size: 20.0,
                    color: blackColor,
                  ),
                ),
              )),
          Positioned(
              top: 60,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white),
                    child: Icon(
                      Icons.layers,
                      color: blackColor,
                    )),
              )),
          Positioned(
              top: 60,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: blackColor,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
