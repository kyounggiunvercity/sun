import 'package:app_bar_menu/map/map_important_location.dart';
import 'package:app_bar_menu/map/map_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'package:app_bar_menu/map_support/google_map_service.dart';
import 'package:app_bar_menu/map_support//place.dart';



class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapTotal();
  }
}

class MapTotal extends StatefulWidget {
  @override
  State<MapTotal> createState() => _MapTotalState();
}

class _MapTotalState extends State<MapTotal> {
  final TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  var sessionToken;
  var googleMapServices;
  PlaceDetail placeDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();

  Position position;
  double distance = 0.0;
  String myAddr = '';

  @override
  void initState() {
    super.initState();
    _checkGPSAvailability();
  }

  void _checkGPSAvailability() async {
    GeolocationStatus geolocationStatus =
    await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus);

    if (geolocationStatus != GeolocationStatus.granted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('GPS 사용 불가'),
            content: Text('GPS 사용 불가로 앱을 사용할 수 없습니다'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ).then((_) => Navigator.pop(context));
    } else {
      await _getGPSLocation();
      myAddr = await GoogleMapServices.getAddrFromLocation(
          position.latitude, position.longitude);
      _setMyLocation();
    }
  }

  Future<void> _getGPSLocation() async {
    position = await Geolocator().getCurrentPosition();
    print('latitude: ${position.latitude}, longitude: ${position.longitude}');
  }

  void _setMyLocation() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: '내 위치', snippet: myAddr),
      ));
    });
  }

  void _moveCamera() async {
    if (_markers.length > 0) {
      setState(() {
        _markers.clear();
      });
    }

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(placeDetail.lat, placeDetail.lng),
      ),
    );

    await _getGPSLocation();
    myAddr = await GoogleMapServices.getAddrFromLocation(
        position.latitude, position.longitude);

    distance = await Geolocator().distanceBetween(position.latitude,
        position.longitude, placeDetail.lat, placeDetail.lng);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(placeDetail.placeId),
          position: LatLng(placeDetail.lat, placeDetail.lng),
          infoWindow: InfoWindow(
            title: placeDetail.name,
            snippet: placeDetail.formattedAddress,
          ),
        ),
      );
    });
  }





  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: const Color(0xFFecec1c),
        appBar: AppBar(
            title:    Text('1층, 반려동물, 등, 등',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepOrange
            ) ,),
            leading: TextButton(
              onPressed: (){
              },
              child:  SizedBox(
                height: 40,
                width: 40,
                child: Icon(Icons.arrow_back_rounded),

              ),

            ),
            backgroundColor: const Color(0xFFecec1c),
            actions:<Widget>[ IconButton(
              icon: const Icon(Icons.star),
              tooltip: 'favorite',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PickLocation()));

              },
            )]),
      body: Stack(
        children: <Widget>[
      GoogleMap(
      mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            37.382782,
            127.118905,
          ),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: _markers,
      ),
    ])
    );
  }
}
