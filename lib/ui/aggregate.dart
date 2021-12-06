import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_it/ui/components/days.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weekly Schedule",
          style: TextStyle(fontFamily: "Comfortaa"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/abstract.jpeg'), fit: BoxFit.cover
            )
        ),
        height: MediaQuery.of(context).size.height - 150.0,
        child: VerticalTabs(
          indicatorColor: Colors.purple,
          selectedTabBackgroundColor: Colors.blue.withOpacity(0.1),
          tabsWidth: MediaQuery.of(context).size.width / 5.8,
          direction: TextDirection.ltr,
          contentScrollAxis: Axis.horizontal,
          changePageDuration: Duration(milliseconds: 500),
          tabs: <Tab>[
            Tab(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Mon',
                    style: TextStyle(fontFamily: "RobotoCondensed")),
              ),
            ),
            Tab(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text('Tue', style: TextStyle(fontFamily: "RobotoCondensed")),
                )),
            Tab(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Wed',
                    style: TextStyle(fontFamily: "RobotoCondensed")),
              ),
            ),
            Tab(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text('Thur', style: TextStyle(fontFamily: "RobotoCondensed")),
                )),
            Tab(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text('Fri', style: TextStyle(fontFamily: "RobotoCondensed")),
                )),
            Tab(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text('Sat', style: TextStyle(fontFamily: "RobotoCondensed")),
                )),
            Tab(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text('Sun', style: TextStyle(fontFamily: "RobotoCondensed")),
                )),
          ],
          contents: <Widget>[
            DayOfTheWeek("MONDAY"),
            DayOfTheWeek("TUESDAY"),
            DayOfTheWeek("WEDNESDAY"),
            DayOfTheWeek("THURSDAY"),
            DayOfTheWeek("FRIDAY"),
            DayOfTheWeek("SATURDAY"),
            DayOfTheWeek("SUNDAY"),
            //tabsContent('Activities')
          ],
        ),
      ),
    );
  }
}

Widget tabsContent(String caption, [String description = '']) {
  return Container(
    margin: EdgeInsets.all(5.0),
    padding: EdgeInsets.all(10.0),
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Text(
          caption,
          style: TextStyle(fontSize: 25),
        ),
        Divider(
          height: 20,
          color: Colors.black45,
        ),
        Text(
          description,
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    ),
  );
}
