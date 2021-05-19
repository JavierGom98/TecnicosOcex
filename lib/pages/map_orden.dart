import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'directions_model.dart';
import 'directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng fromPoint = LatLng(7.888115, -72.498502);
LatLng toPoint = LatLng(7.897925, -72.490047);

class MapScreen extends StatefulWidget {
  MapScreen();
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Location location = Location();
  LocationData currentLocation;

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _actual;
  Marker _destination;
  Directions _info;

  bool seguirActual = false;
  IconData iconSeguir = FontAwesomeIcons.mapMarkerAlt;

  @override
  void initState() {
    super.initState();
    //Actualiza en tiempo real
    location.onLocationChanged().listen((LocationData cLoc) {
      if(seguirActual)
        viewGps();
    });
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(7.888115, -72.498502),
    zoom: 13.5,
  );

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/orden_page');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              _onBackPressed();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Navegacion"),
          backgroundColor: Color(0xFF0277bc),
          actions: [
            if (_origin != null)
              TextButton(
                onPressed: () {
                  updateOrigen();
                },
                style: TextButton.styleFrom(
                  primary: Colors.teal[100],
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('ORIGEN'),
              ),
            if (_destination != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _destination.position,
                      zoom: 16.5,
                      tilt: 40.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.red[200],
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('DEST'),
              )
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              markers: {
                if (_origin != null) _origin,
                if (_destination != null) _destination
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            if (_info != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_info.totalDistance}, ${_info.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            Align(  //Activar seguimiento
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(bottom: 20, left: 15),
                width: 40,
                child: FloatingActionButton(
                  backgroundColor: Color(0xFF0277bc),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    if(!seguirActual){
                      seguirActual = true;
                      setState(() {
                        iconSeguir = FontAwesomeIcons.mapMarker;
                      });
                      viewGps();
                    }else{
                      seguirActual = false;
                      setState(() {
                        iconSeguir = FontAwesomeIcons.mapMarkerAlt;
                      });
                    }
                  },
                  child: Icon(iconSeguir, size: 15,),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          onPressed: () {
            seguirActual = false;
            setState(() {
              iconSeguir = FontAwesomeIcons.mapMarkerAlt;
            });
            _googleMapController.animateCamera(
              _info != null
                  ? CameraUpdate.newLatLngBounds(_info.bounds, 80.0)
                  : CameraUpdate.newCameraPosition(_initialCameraPosition),
            );
          },
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
    );
  }

  updateCurrentLocation() async {
    currentLocation = await location.getLocation();
    fromPoint = LatLng(currentLocation.latitude, currentLocation.longitude);
    await _addMarker(fromPoint);
    await _addMarker(toPoint);
    _centerView();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _googleMapController = controller;
    updateCurrentLocation();
  }

  updateOrigen() async {
    currentLocation = await location.getLocation();
    fromPoint = LatLng(currentLocation.latitude, currentLocation.longitude);
    await _addMarker(fromPoint);
    await _addMarker(toPoint);
    updateCameraMap();
  }

  updateCameraMap() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _actual.position,
          zoom: 16.5,
          tilt: 40.0,
        ),
      ),
    );
  }

  viewGps() async {
    print('viewGps');
    currentLocation = await location.getLocation();
    _actual = Marker(
      markerId: MarkerId('actual'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    updateCameraMap();
  }

  _centerView() async {
    await _googleMapController.getVisibleRegion();

    var left = min(fromPoint.latitude, toPoint.latitude);
    var right = max(fromPoint.latitude, toPoint.latitude);
    var top = max(fromPoint.longitude, toPoint.longitude);
    var bottom = min(fromPoint.longitude, toPoint.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, bottom),
      northeast: LatLng(right, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 80);
    _googleMapController.animateCamera(cameraUpdate);
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origen'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: pos,
        );
        _actual = _origin;
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destino'),
          //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin.position, destination: pos);
      setState(() => _info = directions);
    }
  }

}