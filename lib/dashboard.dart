import 'package:flutter/material.dart';


class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workload Scheduling System'),
        backgroundColor: Colors.blue,
      ),
        bottomNavigationBar: new BottomNavigationBar(items: [
          new BottomNavigationBarItem
            (icon: new Icon(Icons.home), title: new Text("Home")),
          new BottomNavigationBarItem
            (icon: new Icon(Icons.folder_open), title: new Text("About")),
          new BottomNavigationBarItem
            (icon: new Icon(Icons.settings), title:  new Text("Settings")),
    ]),
    );
  }
}
