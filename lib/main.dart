import 'package:flutter/material.dart';
import 'insights.dart';
import 'calendar.dart';
import 'home.dart'; //for testing, temporary
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();   //STT: consider saying new _MyApp();
}

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  int _selectedIndex = 0;
  final _widgetOptions = [
    Text('Index 0: Insights'),
    Text('Index 1: Calendar'),
    Text('Index 2: Discover')
  ];

  InsightsWidget _insightsWidget;
  CalendarWidget _calendarWidget;
  HomeWidget _testWidget;
  List<Widget> _children;

  _MyApp() {
    if (this._insightsWidget == null) {
      this._insightsWidget = new InsightsWidget();
    }
    this._calendarWidget = new CalendarWidget();
    this._testWidget = new HomeWidget();
    this._children = [
      //need list series as insights widget parameter
      this._insightsWidget,
      this._calendarWidget,
      this._testWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          )
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pecto Pro'),
        ),
        body: _children[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), title: Text('Insights')),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text('Calendar')),
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Discover')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.lightBlue,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}



