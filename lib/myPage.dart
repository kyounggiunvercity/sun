import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_room_app/menu.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFecec1c),
        appBar: AppBar(
            title:    Text('My Page',style: TextStyle(
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
              },
            )]),
        body: Column(
        ),
  );
  }
}
