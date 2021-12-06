import 'package:flutter/material.dart';
import 'package:schedule_it/model/activity_item.dart';
import 'package:schedule_it/util/database_client.dart';
import 'package:schedule_it/util/date_formatter.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() =>  _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _activityNameEditingController =  TextEditingController();
  final TextEditingController _startTimeEditingController =  TextEditingController();
  final TextEditingController _endTimeEditingController =  TextEditingController();
  final TextEditingController _locationEditingController =  TextEditingController();
  final TextEditingController _descriptionEditingController =  TextEditingController();
  var db =  DatabaseHelper();
  final List<ActivityItem> _itemList = <ActivityItem>[];


  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmitted(String activityName, String startTime, String endTime, String description, String location) async {
    _activityNameEditingController.clear();
    _startTimeEditingController.clear();
    _endTimeEditingController.clear();
    _locationEditingController.clear();
    _descriptionEditingController.clear();

    ActivityItem activityItem =  ActivityItem(activityName,startTime,endTime,description,location, dateFormatted());
    int savedItemId = await db.saveActivityItem(activityItem);

    ActivityItem addedItem = await db.getActivityItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);

    });


    print("Item saved id: $savedItemId");
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/items.jpeg'), fit: BoxFit.cover)
        ),
        child: Column(
          children: <Widget>[
            Flexible(
              child:  ListView.builder(
                  padding:  EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    return  Card(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0), ),
                      elevation: 5.0,
                      //color: Colors.white10,
                      child:  ListTile(
                        title: _itemList[index],
                        onLongPress: () => _updateItem(_itemList[index], index),
                        trailing:  Listener(
                          key:  Key(_itemList[index].activityName),
                          child:   Icon(Icons.remove_circle_outline,
                            color: Colors.redAccent,),
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


      floatingActionButton:  FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.lightGreen,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add, size: 30.0,),
            ],
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert =  AlertDialog(
      contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      content:  Row(
        children: <Widget>[
          Expanded(
              child:  Container(
                height: 300.0,
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: _activityNameEditingController,
                      autofocus: true,
                      decoration:  InputDecoration(
                        labelText: "Event name",
                        hintText: "Enter event name",
                      ),
                    ),
                    TextField(
                      controller: _startTimeEditingController,
                      autofocus: true,
                      decoration:  InputDecoration(
                        labelText: "Start time",
                        hintText: "Enter start time",

                      ),
                    ),
                    TextField(
                      controller: _endTimeEditingController,
                      autofocus: true,
                      decoration:  InputDecoration(
                        labelText: "End time",
                        hintText: "Enter End time",
                      ),
                    ),
                    TextField(
                      controller: _locationEditingController,
                      autofocus: true,
                      decoration:  InputDecoration(
                        labelText: "Location",
                        hintText: "Enter location",
                      ),
                    ),
                    TextField(
                      controller: _descriptionEditingController,
                      autofocus: true,
                      decoration:  InputDecoration(
                        labelText: "Description",
                        hintText: "Enter description",
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),
      actions: <Widget>[
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            color: Colors.blueAccent,
            onPressed: () {
              _handleSubmitted(_activityNameEditingController.text, _startTimeEditingController.text, _endTimeEditingController.text,
                  _locationEditingController.text, _descriptionEditingController.text);
              _activityNameEditingController.clear();
              _startTimeEditingController.clear();
              _endTimeEditingController.clear();
              _locationEditingController.clear();
              _descriptionEditingController.clear();

              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: Colors.white),)),
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white),))

      ],
    );
    showDialog(context: context,
        builder:(_) {
          return alert;

        });
  }

  _readNoDoList() async {
    List items = await db.getActivityItems();
    items.forEach((item) {
      // ActivityItem noDoItem = ActivityItem.fromMap(item);
      setState(() {
        _itemList.add(ActivityItem.map(item));
      });
      // print("Db items: ${noDoItem.activityName}");
    });

  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteActivityItem(id);
    setState(() {
      _itemList.removeAt(index);
    });


  }

  _updateItem(ActivityItem item, int index) {
    var alert =  AlertDialog(
      contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      title:  Text("Update Item"),
      content:  Form(
        key: _key,
        child: Container(
          height: 300.0,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _activityNameEditingController,
                autofocus: true,
                decoration:  InputDecoration(
                  labelText: "Event name",
                  hintText: "Enter event name",
                ),
              ),
              TextFormField(
                controller: _startTimeEditingController,
                autofocus: true,
                decoration:  InputDecoration(
                  labelText: "Start time",
                  hintText: "Enter start time",

                ),
              ),
              TextFormField(
                controller: _endTimeEditingController,
                autofocus: true,
                decoration:  InputDecoration(
                  labelText: "End time",
                  hintText: "Enter End time",
                ),
              ),
              TextFormField(
                controller: _locationEditingController,
                autofocus: true,
                decoration:  InputDecoration(
                  labelText: "Location",
                  hintText: "Enter location",
                ),
              ),
              TextFormField(
                controller: _descriptionEditingController,
                autofocus: true,
                decoration:  InputDecoration(
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
                borderRadius: BorderRadius.circular(20.0)
            ),
            onPressed: () async {
              ActivityItem activityItemUpdated = ActivityItem.fromMap(
                  {"activityName": _activityNameEditingController.text,
                    "startTime": _startTimeEditingController.text,
                    "endTime": _endTimeEditingController.text,
                    "location": _locationEditingController.text,
                    "description": _descriptionEditingController.text,
                    "dateCreated" : dateFormatted(),
                    "id" : item.id
                  });

              _handleSubmittedUpdate(index, item);//redrawing the screen
              await db.updateActivityItem(activityItemUpdated); //updating the item
              setState(() {
                _readNoDoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);

            },
            child:  Text("Update", style: TextStyle(color: Colors.white),)),
        RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            onPressed: () => Navigator.pop(context),
            child:  Text("Cancel", style: TextStyle(color: Colors.white),))
      ],
    );
    showDialog(context:
    context ,builder: (_) {
      return alert;
    });



  }

  void _handleSubmittedUpdate(int index, ActivityItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].activityName == item.activityName;

      });

    });
  }
}
