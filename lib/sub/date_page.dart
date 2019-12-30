import 'package:flutter/material.dart';
import 'package:push_up_pro/insights.dart';
import 'exercise_entry.dart';

class DatePage extends StatelessWidget {
  final DateTime dateTime;
  final List<ListItem> exercises;
  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  DatePage({Key key, this.dateTime, this.exercises}) : super(key: key);

  Widget _buildAppBar() {}

  @override
  Widget build(BuildContext context) {
    String tag = "card" +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString();
    return new Hero(
        tag: tag,
        child: Scaffold(
          appBar: new AppBar(
            title: Text(
              '${_months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
          body:  new Column(
                  children: <Widget>[
                    Container(

                      child: Text(
                        'Workouts',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),

                    (exercises != null)
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(8),
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              final item = exercises[index];

                              if (item is GraphContainer) {
                                return item.graphList;
                              } else if (item is ExerciseEntry) {
                                return item;
                              }
                            })
                        : new Container(),
                  ],
                ),
        ));
  }
}
