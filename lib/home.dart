import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
//try making home widget stateful widget to test if main is buggy
  @override
  State createState() => new HomeWidgetState();

}

class HomeWidgetState extends State<HomeWidget> {

  Widget build(BuildContext context) {
    return new Scaffold(
      body: Text("stateful test"),
    );
  }
}