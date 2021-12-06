import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_it/model/table_item.dart';
import 'package:schedule_it/util/database_client.dart';

class DayOfTheWeek extends StatefulWidget {
  final String day;

  const DayOfTheWeek(this.day);

  @override
  _DayOfTheWeekState createState() => _DayOfTheWeekState();
}

class _DayOfTheWeekState extends State<DayOfTheWeek> {
  var db = DatabaseHelper();
  final List<TableItem> _itemList = <TableItem>[];

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150.0,
      child: Container(
          color: Colors.blue.withOpacity(0.1),
          child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  //color: Colors.white10,
                  child: ListTile(
                    title: _itemList[index],
                    //onLongPress: () => _updateItem(_itemList[index], index),
                    trailing: Listener(
                      key: Key(_itemList[index].activityName),
                      child: Icon(
                        Icons.hdr_strong,
                        color: Colors.purple,
                      ),
//                            onPointerDown: (pointerEvent) =>
//                                _deleteNoDo(_itemList[index].id, index),
                    ),
                  ),
                );
              })),
    );
  }

  _readNoDoList() async {
    List items = await db.getDayItems(widget.day);
    items.forEach((item) {
      // ActivityItem noDoItem = ActivityItem.fromMap(item);
      setState(() {
        _itemList.add(TableItem.map(item));
      });
      // print("Db items: ${noDoItem.activityName}");
    });
  }
}
