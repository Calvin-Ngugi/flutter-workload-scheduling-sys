import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_it/ui/aggregate.dart';
import 'package:schedule_it/ui/timeTablesPage.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'activityPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 10.0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Schedule It",
                style: TextStyle(
                    fontFamily: "YeonSung",
                    fontWeight: FontWeight.normal,
                    fontSize: 30.0),
              )
            ],
          ),
          bottom: TabBar(
              unselectedLabelStyle: TextStyle(
                fontSize: 13.0,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
              ),
              labelStyle: TextStyle(
                  fontFamily: "Comfortaa",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 35.0,
                indicatorColor: Colors.lightGreen,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: [
                Tab(
                  text: "Activities",
                ),
                Tab(
                  text: "Time Tables",
                ),
                Tab(
                  text: "Schedule",
                ),
              ]),
        ),
        body: TabBarView(children: [
          Container(
            margin: const EdgeInsets.all(0.0),
            child: ActivityPage(),
          ),
          Container(
            margin: const EdgeInsets.all(0.0),
            child: TimeTablesPage(),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Schedule(),
          )
        ]),
      ),
    );
  }
}
