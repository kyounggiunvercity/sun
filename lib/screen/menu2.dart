import 'package:flutter/material.dart';

import '../menu.dart';
import '../myPage.dart';

class menu2 extends StatefulWidget {
  @override
  _menu2State createState() => _menu2State();
}

class _menu2State extends State<menu2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFecec1c),
      appBar: AppBar(
          title:    Text('Menu_2',style: TextStyle(
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
