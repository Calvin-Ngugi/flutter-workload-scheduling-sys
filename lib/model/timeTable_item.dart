import 'package:flutter/material.dart';

class TimeTableItem extends StatelessWidget {
  String _timeTableName;
  String _description;
  String _dateCreated;
  int _id;

  TimeTableItem(this._timeTableName, this._description,this._dateCreated,);

  TimeTableItem.map(dynamic obj) {
    this._timeTableName = obj["timeTableName"];
    this._description = obj["description"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get timeTableName => _timeTableName;

  String get description => _description;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["timeTableName"] = _timeTableName;
    map["description"] = _description;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  TimeTableItem.fromMap(Map<String, dynamic> map) {
    this._timeTableName = map["timeTableName"];
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
                Text(
                  "Time Table For :",
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
