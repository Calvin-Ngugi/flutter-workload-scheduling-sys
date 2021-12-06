import 'package:flutter/material.dart';
import 'dart:async';

import 'ui/home.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),()=> Navigator.pushNamed(context, "/ui/home"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [new Color(0xff6094e8), new Color(0xff60fabc)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 65.0,
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Icon(
                    Icons.calendar_today,
                    color: Colors.deepOrange,
                    size: 50.0,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0)
              ),
              Text(
                'Workload Scheduling System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
