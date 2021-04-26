import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:app_bar_menu/map_support/google_map_service.dart';

class BigMap extends StatefulWidget {
  @override
  _BigMapState createState() => _BigMapState();
}

class _BigMapState extends State<BigMap> {
  Position position;
  Completer<GoogleMapController> _controller = Completer();
  LatLng selectedLocation;
  bool loading = false;
  String selectedAddress;

  @override
  void initState() {
    super.initState();
    _setInitialPostion();
  }

  _setInitialPostion() async {
    position = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  _selectLocation(LatLng loc) async {
    setState(() => loading = true);
    selectedAddress = await GoogleMapServices.getAddrFromLocation(
        loc.latitude, loc.longitude);
    setState(() {
      loading = false;
      selectedLocation = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     appBar: AppBar(
       backgroundColor: const Color(0xFFecec1c),
        title: Text('찜할 집을 찾으시오',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.deepOrange
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check,
              color: Colors.deepOrange,),
            onPressed: selectedLocation == null
                ? null
                : () => Navigator.of(context).pop({
              'latitude': selectedLocation.latitude,
              'longitude': selectedLocation.longitude,
              'address': selectedAddress,
            }),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: position == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : GoogleMap(
          onTap: _selectLocation,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: 16,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: selectedLocation == null
              ? null
              : {
            Marker(
              markerId: MarkerId('selectedLocation'),
              position: selectedLocation,
              infoWindow: InfoWindow(
                title: '선택된 위치',
                snippet: selectedAddress,
              ),
            ),
          },
        ),
      ),
    );
  }
}