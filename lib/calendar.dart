import 'package:flutter/material.dart';
import 'package:push_up_pro/insights.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:push_up_pro/sub/date_page.dart';
import 'package:push_up_pro/sub/date_page.dart';
import 'package:push_up_pro/sub/fut_date_page.dart';
import 'package:push_up_pro/sub/exercise_entry.dart';
import 'package:push_up_pro/sub/new_entry.dart';

class CalendarWidget extends StatefulWidget {

  @override
  State createState() => new CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget>{

  static List<ListItem> scheduledExercises = [];
  bool entryPresent = false;
  DateTime today = new DateTime.now();

  @override
  void initState(){
    super.initState();

  }

  void handleNewDate(date) {
    print("handleNewDate ${date}");
  }

  bool isFuture(DateTime day){
    bool inFuture = false;
    if (day.year > today.year && !isPresent(day)){
      inFuture = true;
    } else {
      if (day.month > today.month){
        inFuture = true;
      } else {
        if(day.day > today.day){
          inFuture = true;
        }
  }
    }
    return inFuture;
  }

  bool isPresent(DateTime day){
    bool present = false;
    for(ListItem item in InsightsWidgetState.insightsItems){
      if(item is ExerciseEntry){
        if(item.dateTime.month == day.month && item.dateTime.day == day.day && item.dateTime.year == day.year){
          present = true;
        }
      }
    }
    return present;
  }

  bool isScheduled (DateTime day){
    bool present = false;
    for(ListItem item in scheduledExercises){
      if(item is ExerciseEntry){
        if(item.dateTime.month == day.month && item.dateTime.day == day.day && item.dateTime.year == day.year){
          present = true;
        }
      }
    }
    return present;
  }

  List _exercises(DateTime day) {
    List<ListItem> dayExercises = [];
    for(ListItem item in InsightsWidgetState.insightsItems){
      if(item is ExerciseEntry){
        if(item.dateTime.month == day.month && item.dateTime.day == day.day && item.dateTime.year == day.year){
          dayExercises.add(item);
        }
      }
    }
    return dayExercises;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: new Container(
          margin: new EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 10.0,
          ),
          child: new Calendar(
                onSelectedRangeChange: (range) =>
                    print("Range is ${range.item1}, ${range.item2}"),
                isExpandable: true,
                dayBuilder: (BuildContext context, DateTime day) {
                  return new InkWell(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 200));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return (!isFuture(day)) ? new DatePage(
                                dateTime: day,
                                exercises: _exercises(day))
                                : new FutureDatePage(day);
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black38)),
                      child: new Center(
                        child: Column(
                          children: <Widget>[
                            new Text(
                              day.day.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal
                              ),
                            ),

                            isPresent(day) ? Container(
                              alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Icon(
                                  Icons.lens,
                                  color: Colors.grey,
                                  size: 10,
                                )
                            ): new Container(),

                            isScheduled(day) ? Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Icon(
                                  Icons.lens,
                                  color: Colors.green,
                                  size: 10,
                                )
                            ): new Container()

                          ],
                        )
                      )
                    ),
                  );
                },
              ),
          ),
        );

  }
}

