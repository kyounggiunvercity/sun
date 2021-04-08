import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:to_room_app/widget.dart';
import 'package:to_room_app/myPage.dart';
import 'favorite.dart';

class ToRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.amber,
        ),
        home: ToRoomScaffold());
  }
}

class ToRoomScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFecec1c),
        appBar: AppBar(
          title:    Text('Main Menu',style: TextStyle(
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
            actions:<Widget>[ IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: 'My Page',
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyPage()));
              },
            )]),
        body: Column(
          children:<Widget> [
            MenuBox()
          ],
        ),
        floatingActionButton: Container(padding: EdgeInsets.only(right: 20, bottom: 10,),
          child:
          IconButton(
            icon: const Icon(Icons.bookmarks,size: 30,
              color: Colors.amber,),
            tooltip: 'Favorite',
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => Favorite()));
            },
          )
        ));
  }
}
