import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoomInOutMaps extends StatefulWidget {
  @override
  _ZoomInOutMapsState createState() => _ZoomInOutMapsState();
}

class _ZoomInOutMapsState extends State<ZoomInOutMaps> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Zoom in and Out of Google Maps'),
          backgroundColor: Colors.red,
        ),
        body: GoogleMap(
          //enable zoom gestures
          zoomGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}