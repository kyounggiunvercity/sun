
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_bar_menu/map/map_important_location.dart';
import 'package:app_bar_menu/map/map_pick.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:app_bar_menu/map_support/google_map_service.dart';
import 'package:app_bar_menu/map_support/place.dart';
import 'package:http/http.dart' as http;
import 'package:app_bar_menu/constants/constants.dart';
import 'package:app_bar_menu/map_support/map_marker.dart';

import 'map_support/map_marker_cluster.dart';




class Total extends StatefulWidget {
  @override
  _TotalState createState() => _TotalState();
}

class _TotalState extends State<Total> {

  var uuid = Uuid();
  var sessionToken;
  var googleMapServices;
  PlaceDetail placeDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();

  LatLng _center;
  Position currentLocation;
  double distance = 0.0;
  String myAddr = '';

  bool loading = false;
  LatLng selectedLocation;
  String selectedAddress;

  Uint8List markerIcon;


  final TextEditingController _searchController = TextEditingController();
  LatLng position;


  final tcontroller = TextEditingController();
  Widget appBarTitle = new Text("map");
  Icon actionIcon = new Icon(Icons.search);


    Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    myAddr = await GoogleMapServices.getAddrFromLocation(
        currentLocation.latitude, currentLocation.longitude);
    _setMyLocation(currentLocation.latitude, currentLocation.longitude, myAddr);


  }


  void setCustomMarker(addr) async{
    markerIcon = await getBytesFromCanvas(300, 100, addr);
  }

  void _setMyLocation(latitude, longtitude, Addr) {
    var _latitude = latitude;
    var _longtitude = longtitude;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: LatLng(_latitude, _longtitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap:(){} ,
        infoWindow: InfoWindow(title: '나의 위치', snippet: Addr, ),
      ));
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker('내 위치');
    getUserLocation();

  }


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _selectLocation(LatLng loc) async {
    setState(() {
      loading = true;
      _setMyLocation(loc.latitude, loc.longitude, selectedAddress);
    });
    selectedAddress = await GoogleMapServices.getAddrFromLocation(loc.latitude, loc.longitude);
    setState(() {
      loading = false;
      selectedLocation = loc;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.brown,
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
                  child: Icon(Icons.search,
                    color: Colors.deepOrange,),
                ),

              ),
              backgroundColor: Colors.brown,
              actions:<Widget>[ IconButton(
                icon: const Icon(Icons.star,
                color: Colors.deepOrange,),
                tooltip: 'favorite',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImportantLocations()));

                },
              )]),
          body: Stack(
            children: <Widget>[
              _center == null
                  ? Center(child: CircularProgressIndicator())
                  : ModalProgressHUD(
                inAsyncCall: loading,
                child: GoogleMap(
                  onTap: _selectLocation,
                  initialCameraPosition:
                  CameraPosition(target: _center, zoom: 16),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: _markers,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, right: 10),
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      onPressed: () {
                        stateStterSearch();
                      },

                      label: Text('현 위치 아파트', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.yellow
                      ),),
                      elevation: 8,
                      icon: Icon(Icons.gps_fixed_outlined,color: Colors.yellow,size: 20,),
                      backgroundColor: Colors.brown,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        stateStterPointSearch();
                      },
                      label: Text('주변 아파트'
                          ,  style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.yellow)),
                      elevation: 8,
                      icon: Icon(Icons.map, color: Colors.yellow,size: 20,),
                      backgroundColor: Colors.brown,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void stateStterSearch() {
    setState(() {
      _search(currentLocation.latitude, currentLocation.longitude);
    });
  }

  void stateStterPointSearch() {
    setState(() {
      _pointSearch(selectedLocation.latitude, selectedLocation.longitude);
    });
  }

  void _search(dynamic latitude, dynamic longtitude) async {
    setState(() {
      _markers.clear();
      getUserLocation();
      loading = true;

    });

    var _latitude = latitude;
    var _longtitude = longtitude;
    var _places = '아파트';
    final String url =
        '$baseUrl?key=$API_KEY&location=$_latitude,$_longtitude&keyword=$_places&radius=500&language=ko';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(_center, 16));

        setState(() {

          final foundPlaces = data['results'];

          for (int i = 0; i < foundPlaces.length; i++) {
            setCustomMarker(foundPlaces[i]['name']);
            _markers.add(
              Marker(

                markerId: MarkerId(foundPlaces[i]['place_id']),
                position: LatLng(
                  foundPlaces[i]['geometry']['location']['lat'],
                  foundPlaces[i]['geometry']['location']['lng'],
                ),
                icon: BitmapDescriptor.fromBytes(markerIcon),
                infoWindow: InfoWindow(
                  title: foundPlaces[i]['name'],
                  snippet: foundPlaces[i]['vicinity'],
                ),
                onTap: (){

                  showAlertDialog(context, _latitude,_longtitude);

                }
              ),
            );
          }
          loading = false;
        });
      }
    } else {
      print('Fail to fetch place data');
    }
  }

  void _pointSearch(dynamic latitude, dynamic longtitude) async {
    var _latitude = latitude;
    var _longtitude = longtitude;
    var _places = '아파트';
    setState(() {
      loading = true;
      _markers.clear();
      _setMyLocation(_latitude, _longtitude, selectedAddress);
    });
    final String url =
        '$baseUrl?key=$API_KEY&location=$_latitude,$_longtitude&keyword=$_places&radius=500&language=ko';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          final foundPlaces = data['results'];

          for (int i = 0; i < foundPlaces.length; i++) {
            setCustomMarker(foundPlaces[i]['name']);
            _markers.add(
              Marker(
                markerId: MarkerId(foundPlaces[i]['place_id']),
                position: LatLng(
                  foundPlaces[i]['geometry']['location']['lat'],
                  foundPlaces[i]['geometry']['location']['lng'],
                ),
                icon: BitmapDescriptor.fromBytes(markerIcon),
                infoWindow: InfoWindow(
                  title: foundPlaces[i]['name'],
                  snippet: foundPlaces[i]['vicinity'],
                ),
                      onTap: (){
                  showAlertDialog(context,_latitude,_longtitude);

                      }
              ),
            );
          }
          loading = false;
        });
      }
    } else {
      print('Fail to fetch place data');
    }
  }
}

void showAlertDialog(BuildContext context,_latitude, _longtitude) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        titlePadding: EdgeInsets.fromLTRB(25, 30, 5, 5),
        backgroundColor: Colors.brown,
        title: Text('즐겨찾기로 등록하시겠습니까?', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.deepOrange)),
        actions: <Widget>[
          FlatButton(
            child: Text('OK', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepOrange)),
            onPressed: () {
                  () => Navigator.of(context).pop({
                'latitude': _latitude,
                'longitude': _longtitude,
              });

            },
          ),
          FlatButton(
            child: Text('Cancel', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepOrange)),
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
          ),
        ],
      );
    },
  );
}


final Fluster<MapMarker> fluster = Fluster<MapMarker>(
  minZoom: minZoom, // The min zoom at clusters will show
  maxZoom: maxZoom, // The max zoom at clusters will show
  radius: 150, // Cluster radius in pixels
  extent: 2048, // Tile extent. Radius is calculated with it.
  nodeSize: 64, // Size of the KD-tree leaf node.
  points: markers, // The list of markers created before
  createCluster: ( // Create cluster marker
      BaseCluster cluster,
      double lng,
      double lat,
      ) => MapMarker(
    id: cluster.id.toString(),
    position: LatLng(lat, lng),
    icon: clusterImage,
    isCluster: cluster.isCluster,
    clusterId: cluster.id,
    pointsSize: cluster.pointsSize,
    childMarkerId: cluster.childMarkerId,
  ),
);

final List<Marker> googleMarkers = fluster
    .clusters([-180, -85, 180, 85], currentZoom)
    .map((cluster) => cluster.toMarker())
    .toList()


