import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  String _activityName;
  String _startTime;
  String _endTime;
  String _location;
  String _description;
  String _dateCreated;
  int _id;

  ActivityItem(this._activityName, this._startTime,
      this._endTime, this._location, this._description,this._dateCreated,);

  ActivityItem.map(dynamic obj) {
    this._activityName = obj["activityName"];
    this._startTime = obj["startTime"];
    this._endTime = obj["endTime"];
    this._location = obj["location"];
    this._description = obj["description"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get activityName => _activityName;

  String get startTime => _startTime;

  String get endTime => _endTime;

  String get location => _location;

  String get description => _description;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["activityName"] = _activityName;
    map["startTime"] = _startTime;
    map["endTime"] = _endTime;
    map["location"] = _location;
    map["description"] = _description;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ActivityItem.fromMap(Map<String, dynamic> map) {
    this._activityName = map["activityName"];
    this._startTime = map["startTime"];
    this._endTime = map["endTime"];
    this._location = map["location"];
    this._description = map["description"];
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
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Activity Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "RobotoCondensed",
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
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

                Row(
                  children: <Widget>[
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
                  ],
                ),
                SizedBox(height: 5.0,),
                Text(
                  "Description",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 5.0,),
                Text(
                  _description,
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
