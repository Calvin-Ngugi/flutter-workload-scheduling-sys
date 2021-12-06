import 'package:flutter/material.dart';
import 'package:schedule_it/model/timeTable_item.dart';
import 'package:schedule_it/util/database_client.dart';
import 'package:schedule_it/util/date_formatter.dart';

import 'tablePage.dart';

class TimeTablesPage extends StatefulWidget {
  @override
  _TimeTablesPageState createState() => _TimeTablesPageState();
}

class _TimeTablesPageState extends State<TimeTablesPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _timeTableNameEditingController =
  TextEditingController();
  final TextEditingController _descriptionEditingController =
  TextEditingController();
  var db = DatabaseHelper();
  final List<TimeTableItem> _itemList = <TimeTableItem>[];

  String _timeTableName;

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmitted(
      String timeTableName,
      String description,
      ) async {
    _timeTableNameEditingController.clear();

    _descriptionEditingController.clear();

    TimeTableItem timeTableItem =
    TimeTableItem(timeTableName, description, dateFormatted());
    int savedItemId = await db.saveTimeTableItem(timeTableItem);

    TimeTableItem addedItem = await db.getTimeTableItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/organize.jpeg'), fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    return Column(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 10.0,
                          //color: Colors.white10,
                          child: ListTile(
                            title: _itemList[index],
//                            onLongPress: () =>
//                                _updateTimeTableItem(_itemList[index], index),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimeTablePage(
                                        _itemList[index].timeTableName))),
                            trailing: Listener(
                              key: Key(_itemList[index].timeTableName),
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 25.0,
                              ),
                              onPointerDown: (pointerEvent) => _deleteNoDo(
                                  _itemList[index].id,
                                  index,
                                  _itemList[index].timeTableName),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    );
                  }),
            ),
            Divider(
              height: 1.0,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.lightGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                size: 30.0,
              ),
            ],
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Row(
        children: <Widget>[
          Expanded(
              child: Form(
                key: _key,
                child: Container(
                  height: 300.0,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _timeTableNameEditingController,
                        autofocus: true,
                        onChanged: (value) {
                          this._timeTableName = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Field cannot be empty";
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Time table name",
                            hintText: "Enter time table name",
                            labelStyle: TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      TextFormField(
                        controller: _descriptionEditingController,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: "Description",
                            hintText: "Enter time table description",
                            labelStyle: TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
      actions: <Widget>[
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.blueAccent,
            onPressed: () {
              if (_key.currentState.validate()) {
                _handleSubmitted(_timeTableNameEditingController.text,
                    _descriptionEditingController.text);

                _timeTableNameEditingController.clear();
                _descriptionEditingController.clear();

                Navigator.pop(context);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getTimeTableItems();
    items.forEach((item) {
      // ActivityItem noDoItem = ActivityItem.fromMap(item);
      setState(() {
        _itemList.add(TimeTableItem.map(item));
      });
      // print("Db items: ${noDoItem.timeTableName}");
    });
  }

  _deleteNoDo(int id, int index, String tTableName) async {
    debugPrint("Deleted Item!");

    await db.deleteDependentTableItem(tTableName);
    await db.deleteTimeTableItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateTimeTableItem(TimeTableItem item, int index) {
    var alert = AlertDialog(
      contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text("Update Item"),
      content: Form(
        key: _key,
        child: Container(
          height: 300.0,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _timeTableNameEditingController,
                autofocus: true,
                onChanged: (value) {
                  this._timeTableName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Field cannot be empty";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Event name",
                  hintText: "Enter event name",
                ),
              ),
              TextFormField(
                controller: _descriptionEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter description",
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
            color: Colors.blueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () async {
              if (_key.currentState.validate()) {
                TimeTableItem timeTableItemUpdated = TimeTableItem.fromMap({
                  "timeTableName": _timeTableNameEditingController.text,
                  "description": _descriptionEditingController.text,
                  "dateCreated": dateFormatted(),
                  "id": item.id
                });

                _handleSubmittedUpdate(index, item); //redrawing the screen
                await db.updateTimeTableItem(timeTableItemUpdated); //updating the item
                setState(() {
                  _readNoDoList(); // redrawing the screen with all items saved in the db
                });

                Navigator.pop(context);
              }
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, TimeTableItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].timeTableName == item.timeTableName;
      });
    });
  }
}
