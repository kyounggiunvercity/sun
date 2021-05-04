import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'map_pick.dart';


void main() => runApp(Tmap());

class Tmap extends StatefulWidget {
  @override
  _TmapState createState() => _TmapState();
}

class _TmapState extends State<Tmap> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _googleMapType = MapType.normal;
  Set<Marker> _markers = Set();
  LatLng _center;
  Position currentLocation;
  double distance = 0.0;
  String myAddr = '';
  bool loading = false;
  LatLng selectedLocation;
  String selectedAddress;
  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    myAddr = await getAddrFromLocation(
        currentLocation.latitude, currentLocation.longitude);
    _setMyLocation(currentLocation.latitude, currentLocation.longitude);
  }

  void _setMyLocation(latitude, longtitude) {
    var _latitude = latitude;
    var _longtitude = longtitude;
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: LatLng(_latitude, _longtitude),

        infoWindow: InfoWindow(title: '아파 위치', snippet: myAddr, ),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
    _markers.add(Marker(
        markerId: MarkerId('myInitialPostion'),
        position: _center != null ? _center : LatLng(37.298456, 127.030481),
        infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?')));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _selectLocation(LatLng loc) async {
    setState(() {
      loading = true;
      _setMyLocation(loc.latitude, loc.longitude);
    });
    selectedAddress = await getAddrFromLocation(loc.latitude, loc.longitude);
    setState(() {
      loading = false;
      selectedLocation = loc;
    });
  }

  static Future<String> getAddrFromLocation(double lat, double lng) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    String url =
        '$baseUrl?latlng=$lat,$lng&key=AIzaSyBjJS0R3g8LUziS9ucwWHmgQr4wXJvIXio&language=ko';

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final formattedAddr = responseData['results'][0]['formatted_address'];
    print(formattedAddr);

    return formattedAddr;
  }

  final tcontroller = TextEditingController();
  Widget appBarTitle = new Text("map");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.brown,
          appBar: AppBar(
              title:    Text('1층, 반려동물, 등, 등',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.yellow
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
              backgroundColor: Colors.brown,
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
              _center == null
                  ? Center(child: CircularProgressIndicator())
                  : ModalProgressHUD(
                inAsyncCall: loading,
                child: GoogleMap(
                  onTap: _selectLocation,
                  initialCameraPosition:
                  CameraPosition(target: _center, zoom: 16),
                  mapType: _googleMapType,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
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
                      label: Text('근처 아파트', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.yellow
                      ),),
                      elevation: 8,
                      icon: Icon(Icons.gps_fixed_outlined,color: Colors.yellow,),
                      backgroundColor: Colors.brown,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        stateStterPointSearch();
                      },
                      label: Text('아파트'
                          ,  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.yellow)),
                      elevation: 8,
                      icon: Icon(Icons.map, color: Colors.yellow,),
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
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBjJS0R3g8LUziS9ucwWHmgQr4wXJvIXio&location=$_latitude,$_longtitude&keyword=$_places&radius=500&language=ko';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(_center, 16));

        setState(() {
          final foundPlaces = data['results'];

          for (int i = 0; i < foundPlaces.length; i++) {
            _markers.add(
              Marker(

                markerId: MarkerId(foundPlaces[i]['place_id']),
                position: LatLng(
                  foundPlaces[i]['geometry']['location']['lat'],
                  foundPlaces[i]['geometry']['location']['lng'],
                ),
                infoWindow: InfoWindow(
                  title: foundPlaces[i]['name'],
                  snippet: foundPlaces[i]['vicinity'],
                ),
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
      _setMyLocation(_latitude, _longtitude);
    });
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyBjJS0R3g8LUziS9ucwWHmgQr4wXJvIXio&location=$_latitude,$_longtitude&keyword=$_places&radius=500&language=ko';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          final foundPlaces = data['results'];

          for (int i = 0; i < foundPlaces.length; i++) {
            _markers.add(
              Marker(
                markerId: MarkerId(foundPlaces[i]['place_id']),
                position: LatLng(
                  foundPlaces[i]['geometry']['location']['lat'],
                  foundPlaces[i]['geometry']['location']['lng'],
                ),
                infoWindow: InfoWindow(
                  title: foundPlaces[i]['name'],
                  snippet: foundPlaces[i]['vicinity'],
                ),
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

Mget() {
  Future<List> getSuggestions(String query) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=AIzaSyBjJS0R3g8LUziS9ucwWHmgQr4wXJvIXio&type=$type&language=ko&components=country:kr';

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }
  }
}

class Place {
  final String description;
  final String placeId;

  Place({this.description, this.placeId});

  Place.fromJson(Map<String, dynamic> json)
      : this.description = json['description'],
        this.placeId = json['place_id'];

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'placeId': this.placeId,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String name;
  final double rating;
  final String vicinity;
  final String website;
  final double lat;
  final double lng;

  PlaceDetail({
    this.placeId,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.name,
    this.rating,
    this.vicinity,
    this.website = '',
    this.lat,
    this.lng,
  });

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.formattedAddress = json['formatted_address'],
        this.formattedPhoneNumber = json['formatted_phone_number'],
        this.name = json['name'],
        this.rating = json['rating'].toDouble(),
        this.vicinity = json['vicinity'],
        this.website = json['website'] ?? '',
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'];

  Map<String, dynamic> toMap() {
    return {
      'placeId': this.placeId,
      'formateedAddress': this.formattedAddress,
      'formateedPhoneNumber': this.formattedPhoneNumber,
      'name': this.name,
      'rating': this.rating,
      'vicinity': this.vicinity,
      'website': this.website,
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}
