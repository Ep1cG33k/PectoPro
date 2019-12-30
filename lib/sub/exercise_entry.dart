import 'package:flutter/material.dart';
import 'package:push_up_pro/insights.dart';
import 'entry_page.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExerciseEntry extends StatelessWidget implements ListItem {
  //STT: make this a full blown constructor.
  //pass the parent container to this class;
  //passing parent may not be as straightforward.
  //may need to look at context object to find a reference to the parent InsightWidgetState instance
  //InsightsWidgetState parent;

  /*
  ExcerciseEntry(InsightWidgetState _insightWidgetState, String _entryTItle, int _reps){
     this.parent = _insightWidgetState;
     this.entryTitle = _entryTItle;
     this.reps = _reps;
  }


   */

  ExerciseEntry(this.index, this.entryTitle, this.exercises, this.dateTime,
      this.duration, {this.diffProg, this.parent}); //STT:get rid of this constructor

  int index;
  double difficulty;
  double timeProg = 1;
  double diffProg = 0.75;
  final String entryTitle;
  final Map<String, int> exercises;
  final DateTime dateTime;
  final Duration duration;
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
  InsightsWidgetState parent;


  void setParent(InsightsWidgetState parent) {
    this.parent = parent;
  }

  void setIndex(int index) {
    this.index = index;
  }

  Widget build(BuildContext context) {
    return new SizedBox(
        width: 100,
        height: 200,
        child: Card(
          elevation: 3,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      entryTitle,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      '${_months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at '
                          '${dateTime.hour}:${dateTime.minute}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            new CircularPercentIndicator(
                              radius: 60.0,
                              animation: true,
                              lineWidth: 7.0,
                              percent: timeProg,
                              center: new Text(duration.inMinutes.toString(),
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                              progressColor: Colors.lightBlue,
                            ),
                            Container(
                              child: Text(
                                'Time',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.normal
                                ),
                              ),
                            )
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: <Widget>[
                              new CircularPercentIndicator(
                                radius: 60.0,
                                animation: true,
                                lineWidth: 7.0,
                                percent: diffProg,
                                center: new Text((diffProg*100).round().toString(),
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold)),
                                progressColor: Colors.redAccent,
                              ),
                              Container(
                                child: Text(
                                  'Difficulty',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.normal
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        //add more progress bars here
                      ],
                    )
                  )
                ],
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                bottom: 0.0,
                right: 0.0,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 200));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return new EntryPage(
                                index: index,
                                entryTitle: entryTitle,
                                exercises: exercises);
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
//                  alignment: Alignment.bottomRight,
                  iconSize: 25,
                  icon: Icon(Icons.delete),
                  onPressed: _deleteEntry,
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _deleteEntry() {
    //STT: with changes above, you should be able to use parent object instead of the static InsightsWidgetState
    int index = InsightsWidgetState.insightsItems.indexOf(this);
    parent.setState(() {
      InsightsWidgetState.insightsItems.removeAt(index);
    });
    print("Index" + index.toString());
  }
}
