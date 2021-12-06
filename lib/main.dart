import 'package:flutter/material.dart';
import 'page1.dart';
import 'ui/home.dart';

var routes=<String,WidgetBuilder>{
  "/page1":(BuildContext context)=> Page1(),
  "/ui/home":(BuildContext context)=> MyHomePage(),
};
void main() {
  runApp(new MaterialApp(
    title: 'Workload Scheduler',
    home: Page1(),
    debugShowCheckedModeBanner: false,
    routes: routes,
  ));
}
