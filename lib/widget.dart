import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/flex.dart';
import 'package:to_room_app/screen/menu1.dart';
import 'package:to_room_app/screen/menu2.dart';
import 'package:to_room_app/screen/menu3.dart';
import 'package:to_room_app/screen/menu4.dart';

class MenuBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(right: 210),
            height: 140,
            width: 200,
            child: MaterialButton(

              shape: CircleBorder(
                  side: BorderSide(
                      width: 2,
                      color: Colors.amber,
                      style: BorderStyle.solid)),
              child: Text('메뉴1'),
              color: const Color(0xFFe88a18),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => menu1()));
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 230),
            height: 140,
            width: 200,
            child: MaterialButton(

              shape: CircleBorder(
                  side: BorderSide(
                      width: 2,
                      color: Colors.amber,
                      style: BorderStyle.solid)),
              child: Text('메뉴2'),
              color: const Color(0xFFe88a18),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => menu2()));
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.only(right: 210),
              height: 140,
              width: 200,
            child: MaterialButton(

              shape: CircleBorder(
                  side: BorderSide(
                      width: 2,
                      color: Colors.amber,
                      style: BorderStyle.solid)),
              child: Text('메뉴3'),
              color: const Color(0xFFe88a18),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => menu3()));
              },
            ),),
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.only(left: 230),
              height: 140,
              width: 200,
            child: MaterialButton(

              shape: CircleBorder(
                  side: BorderSide(
                      width: 2,
                      color: Colors.amber,
                      style: BorderStyle.solid)),
              child: Text('메뉴4'),
              color: const Color(0xFFe88a18),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => menu4()));
              },
            ),),
        ],
      ),
    );
  }
}
