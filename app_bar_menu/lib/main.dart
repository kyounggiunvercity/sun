

import 'package:app_bar_menu/appbar_menu/appbar.dart';
import 'package:app_bar_menu/map/map_big.dart';
import 'package:app_bar_menu/map/map_pick.dart';
import 'package:app_bar_menu/test.dart';
import 'package:app_bar_menu/testing.dart';
import 'package:flutter/material.dart';

import 'package:app_bar_menu/map/map_tmap.dart';
import 'Total.dart';
import 'map/map_auto.dart';
import 'map/map_important_location.dart';
import 'map/map_view.dart';
import 'map/map_location_auto.dart';
import 'package:app_bar_menu/map_support/picked_locations_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
      home: Tmap()
    );
  }
}


