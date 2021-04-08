import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:to_room_app/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: RootPage()

    );
  }
}

