import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:schedule_it/model/table_item.dart';
import 'package:schedule_it/util/database_client.dart';
import 'package:schedule_it/util/date_formatter.dart';

final TextEditingController _activityNameEditingController =
TextEditingController();
final TextEditingController _startTimeEditingController =
TextEditingController();
final TextEditingController _endTimeEditingController = TextEditingController();
final TextEditingController _locationEditingController =
TextEditingController();
//final TextEditingController _dayEditingController = TextEditingController();
//String day;
String theDay = "";

String tablePage;

class TimeTablePage extends StatefulWidget {
  final String timeTableName;

  const TimeTablePage(this.timeTableName);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
//  final TextEditingController _activityNameEditingController =
//      TextEditingController();
//  final TextEditingController _startTimeEditingController =
//      TextEditingController();
//  final TextEditingController _endTimeEditingController =
//      TextEditingController();
//  final TextEditingController _locationEditingController =
//      TextEditingController();
//  final TextEditingController _dayEditingController = TextEditingController();
//  String day;
  var db = DatabaseHelper();
  final List<TableItem> _itemList = <TableItem>[];

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmitted(
      String activityName,
      String startTime,
      String endTime,
      String location,
      String day,
      ) async {
    _activityNameEditingController.clear();
    _startTimeEditingController.clear();
    _endTimeEditingController.clear();
    _locationEditingController.clear();
    //_dayEditingController.clear();

    TableItem activityItem = TableItem(widget.timeTableName, activityName,
        startTime, endTime, location, day, dateFormatted());
    int savedItemId = await db.saveTableItem(activityItem);

    TableItem addedItem = await db.getTableItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.timeTableName,
          style: TextStyle(fontFamily: "Comfortaa"),
        ),
        backgroundColor: Colors.blue,
      ),

      //backgroundColor: Colors.blueAccent,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/items.jpeg'), fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: _itemList[index],
                        onLongPress: () => _updateItem(_itemList[index], index),
                        trailing: Listener(
                          key: Key(_itemList[index].activityName),
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteNoDo(_itemList[index].id, index),
                        ),
                      ),
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
      content: ShowForm(),
      actions: <Widget>[
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.blueAccent,
            onPressed: () {
              _handleSubmitted(
                _activityNameEditingController.text,
                _startTimeEditingController.text,
                _endTimeEditingController.text,
                _locationEditingController.text,
                theDay,
              );
              _activityNameEditingController.clear();
              _startTimeEditingController.clear();
              _endTimeEditingController.clear();
              _locationEditingController.clear();
              // _dayEditingController.clear();

              Navigator.pop(context);
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
    List items = await db.getTableItems(widget.timeTableName);
    items.forEach((item) {
      // ActivityItem noDoItem = ActivityItem.fromMap(item);
      setState(() {
        _itemList.add(TableItem.map(item));
      });
      // print("Db items: ${noDoItem.activityName}");
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteTableItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(TableItem item, int index) {
    var alert = AlertDialog(
      contentPadding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text("Update Item",
        style: TextStyle(
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),
      ),
      titlePadding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
      content: UpdateItemForm(),
      actions: <Widget>[
        RaisedButton(
            color: Colors.blueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () async {
              TableItem activityItemUpdated = TableItem.fromMap({
                "timeTableName": widget.timeTableName,
                "activityName": _activityNameEditingController.text,
                "startTime": _startTimeEditingController.text,
                "endTime": _endTimeEditingController.text,
                "location": _locationEditingController.text,
                "day": theDay,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateTableItem(activityItemUpdated); //updating the item
              setState(() {
                _readNoDoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);
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

  void _handleSubmittedUpdate(int index, TableItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].activityName == item.activityName;
      });
    });
  }
}

class ShowForm extends StatefulWidget {
  @override
  _ShowFormState createState() => _ShowFormState();
}

class _ShowFormState extends State<ShowForm> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  var day;

  String _activityName;

//  final TextEditingController _activityNameEditingController =
//      TextEditingController();
//  final TextEditingController _startTimeEditingController =
//      TextEditingController();
//  final TextEditingController _endTimeEditingController =
//      TextEditingController();
//  final TextEditingController _locationEditingController =
//      TextEditingController();
//  final TextEditingController _dayEditingController = TextEditingController();
//  String day;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        height: 300.0,
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _activityNameEditingController,
              autofocus: true,
              onChanged: (value) {
                this._activityName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "This field cannot be empty";
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Activity name",
                  hintText: "Enter activity name",
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
              controller: _startTimeEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Start time",
                  hintText: "Enter start time",
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
              controller: _endTimeEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "End time",
                  hintText: "Enter End time",
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
              controller: _locationEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Location",
                  hintText: "Enter location",
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
            SizedBox(
              height: 10.0,
            ),
            Text("Select Day :",
                style: TextStyle(fontFamily: "RobotoCondensed")),
            Container(
              height: 30.0,
              width: 250.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        value: 'MONDAY',
                        groupValue: day,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "Monday",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 'TUESDAY',
                        groupValue: day,
                        activeColor: Colors.purple,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "TUESDAY",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 'WEDNESDAY',
                        groupValue: day,
                        activeColor: Colors.deepOrange,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "WEDNESDAY",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 'THURSDAY',
                        groupValue: day,
                        activeColor: Colors.yellow,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "THURSDAY",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 'FRIDAY',
                        groupValue: day,
                        activeColor: Colors.pink,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "FRIDAY",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 'SATURDAY',
                        groupValue: day,
                        activeColor: Colors.brown,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "SATURDAY",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Radio(
                        value: 'SUNDAY',
                        groupValue: day,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            this.day = value;
                          });
                          theDay = day;
                        },
                      ),
                      Text(
                        "SUNDAY",
                        style: TextStyle(
                          fontFamily: "Comfortaa",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UpdateItemForm extends StatefulWidget {
  @override
  _UpdateItemFormState createState() => _UpdateItemFormState();
}

class _UpdateItemFormState extends State<UpdateItemForm> {
  String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: ListView(
        children: <Widget>[
          TextField(
            controller: _activityNameEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Activity name",
                hintText: "Enter activity name",
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
          TextField(
            controller: _startTimeEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Start time",
                hintText: "Enter start time",
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
          TextField(
            controller: _endTimeEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "End time",
                hintText: "Enter End time",
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
          TextField(
            controller: _locationEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Location",
                hintText: "Enter location",
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
          SizedBox(
            height: 10.0,
          ),
          Text("Select Day :", style: TextStyle(fontFamily: "RobotoCondensed")),
          Container(
            height: 30.0,
            width: 250.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio(
                      value: 'MONDAY',
                      groupValue: day,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "Monday",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 'TUESDAY',
                      groupValue: day,
                      activeColor: Colors.purple,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "TUESDAY",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 'WEDNESDAY',
                      groupValue: day,
                      activeColor: Colors.deepOrange,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "WEDNESDAY",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 'THURSDAY',
                      groupValue: day,
                      activeColor: Colors.yellow,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "THURSDAY",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 'FRIDAY',
                      groupValue: day,
                      activeColor: Colors.pink,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "FRIDAY",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 'SATURDAY',
                      groupValue: day,
                      activeColor: Colors.brown,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "SATURDAY",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 'SUNDAY',
                      groupValue: day,
                      activeColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          this.day = value;
                        });
                        theDay = day;
                      },
                    ),
                    Text(
                      "SUNDAY",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
