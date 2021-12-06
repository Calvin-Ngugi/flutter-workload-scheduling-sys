import 'package:flutter/material.dart';

class TableItem extends StatelessWidget {
  String _timeTableName;
  String _activityName;
  String _startTime;
  String _endTime;
  String _location;
  String _day;
  String _dateCreated;
  int _id;

  TableItem( this._timeTableName, this._activityName, this._startTime,
      this._endTime, this._location, this._day,this._dateCreated, );

  TableItem.map(dynamic obj) {
    this._timeTableName = obj["timeTableName"];
    this._activityName = obj["activityName"];
    this._startTime = obj["startTime"];
    this._endTime = obj["endTime"];
    this._location = obj["location"];
    this._day = obj["day"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }


  String get timeTableName => _timeTableName;

  String get activityName => _activityName;

  String get startTime => _startTime;

  String get endTime => _endTime;

  String get location => _location;

  String get day => _day;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["timeTableName"] = _timeTableName;
    map["activityName"] = _activityName;
    map["startTime"] = _startTime;
    map["endTime"] = _endTime;
    map["location"] = _location;
    map["day"] = _day;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  TableItem.fromMap(Map<String, dynamic> map) {
    this._timeTableName = map["timeTableName"];
    this._activityName = map["activityName"];
    this._startTime = map["startTime"];
    this._endTime = map["endTime"];
    this._location = map["location"];
    this._day = map["day"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Time table Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 5.0,),
                Text(
                  _timeTableName,
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                Text(
                  "Activity Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 5.0,),
                Text(
                  _activityName,
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                SizedBox(height: 5.0,),
                Row(
                  children: <Widget>[
                    Text(
                      "Start Time :",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "RobotoCondensed",
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(width: 15.0,),
                    Text(
                      _startTime,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Comfortaa",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                  ],
                ),
                SizedBox(height: 5.0,),
                Row(
                  children: <Widget>[
                    Text(
                      "End Time :",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "RobotoCondensed",
                          fontWeight: FontWeight.bold,

                          fontSize: 18.0),
                    ),
                    SizedBox(width: 20.0,),
                    Text(
                      _endTime,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Comfortaa",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                  ],
                ),
                SizedBox(height: 5.0,),

                Text(
                  "Location :",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(width: 20.0,),
                Text(
                  _location,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                SizedBox(height: 5.0,),
                Text(
                  "Day",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 5.0,),
                Text(
                  _day,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Comfortaa",
                      fontSize: 15.0),
                ),
                SizedBox(height: 5.0,),

                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Created on: $_dateCreated",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontFamily: "Comfortaa",
                        fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
