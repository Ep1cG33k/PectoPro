import 'package:flutter/material.dart';
import 'package:push_up_pro/insights.dart';
import 'package:push_up_pro/calendar.dart';
import 'exercise_entry.dart';
import 'new_entry.dart';

class FutureDatePage extends StatefulWidget {
  final DateTime dateTime;

  FutureDatePage(this.dateTime);
  @override
  State createState() => new FutureDatePageState(dateTime);
}

class FutureDatePageState extends State<FutureDatePage> {
  final DateTime dateTime;
  List<ListItem> exercises = [];
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

  FutureDatePageState(this.dateTime);

  bool isPresent(DateTime day){
    bool present = false;
    for(ListItem item in CalendarWidgetState.scheduledExercises){
      if(item is ExerciseEntry){
        if(item.dateTime.month == day.month && item.dateTime.day == day.day && item.dateTime.year == day.year){
          present = true;
        }
      }
    }
    return present;
  }

  @override
  void initState(){
    populateExercises(dateTime);
  }

  void populateExercises(DateTime day){
    for(ListItem item in CalendarWidgetState.scheduledExercises){
      if(item is ExerciseEntry){
        if(item.dateTime.month == day.month && item.dateTime.day == day.day && item.dateTime.year == day.year){
          exercises.add(item);
          print("here");
        }
      }
    }
    print(CalendarWidgetState.scheduledExercises);
    print(dateTime.month);

  }

  Widget _buildAppBar() {}

  @override
  Widget build(BuildContext context) {
    String tag = "card" +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString();
    return new Scaffold(
            appBar: new AppBar(
              title: Text(
                '${_months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            body: new Column(
              children: <Widget>[
                Container(
                  child: Text(
                    'Scheduled Workouts',
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
            floatingActionButton: _buildFloatingActionButton());
  }

  Widget _buildFloatingActionButton() {
    return new FloatingActionButton(
      onPressed: _openNewEntryDialog,
      child: Icon(
        Icons.add,
        size: 32,
      ),
      tooltip: 'New Entry',
    );
  }

  void _addEntry(ExerciseEntry newEntry) {
    setState(() {
      CalendarWidgetState.scheduledExercises.insert(0, newEntry);
      for (ListItem item in CalendarWidgetState.scheduledExercises) {
        if (item is ExerciseEntry) {
          item.setIndex(CalendarWidgetState.scheduledExercises.indexOf(item));
        }
      }
      populateExercises(dateTime);
//      storage.setItem('key', insightsItems);
//      insightsItems = storage.getItem('key');
    });
  }

  Future _openNewEntryDialog() async {
    ExerciseEntry newEntry =
        await Navigator.of(context).push(new MaterialPageRoute<ExerciseEntry>(
      builder: (BuildContext context) {
        return new NewEntryDialog(0, dateTime: dateTime);
      },
      fullscreenDialog: true,
    ));
    if (newEntry != null) {
      _addEntry(newEntry);
    }
  }
}
