import 'package:flutter/material.dart';

import '../menu.dart';
import '../myPage.dart';


class menu1 extends StatefulWidget {
  @override
  _menu1State createState() => _menu1State();
}

class _menu1State extends State<menu1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFecec1c),
      appBar: AppBar(
          title:    Text('Menu_1',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.deepOrange
          ) ,),
          leading: TextButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ToRoomScaffold()));
            },
            child:  SizedBox(
              height: 40,
              width: 40,
              child: Image.asset('assets/images/RoomGowithB.png'),
            ),

          ),
          backgroundColor: const Color(0xFFecec1c),
          actions: <Widget>[ IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'My Page',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPage()));
            },
          )]),
      body: Column(
      ),
    );
  }
}
