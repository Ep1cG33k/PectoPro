import 'package:flutter/material.dart';
import 'exercise_entry.dart';
import 'package:push_up_pro/insights.dart';

class NewEntryDialog extends StatefulWidget {
  @override
  final int index;
  InsightsWidgetState parent;
  DateTime dateTime = new DateTime.now();

  NewEntryDialog(this.index, {this.parent, this.dateTime});

  NewEntryDialogState createState() => new NewEntryDialogState(index, parent: parent, dateTime: dateTime);
}

class NewEntryDialogState extends State<NewEntryDialog> {
  InsightsWidgetState parent;
  DateTime dateTime = new DateTime.now();
  final int index;
  final entryTitleController = TextEditingController();
  String _entryTitle = 'No Title';
  static Stopwatch _stopwatch = new Stopwatch();
  Duration elapsedTime;
  double diffProg = 0;
  List<entryHolderState> exerciseList = <entryHolderState>[
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
    new entryHolderState(),
  ];
  Map<String, int> exer_reps = {};
  Map<String, double> diffValues = {
    'Easy' : 0,
    'Medium' : .50,
    'Difficult' : 1.00,
  };
  NewEntryDialogState(this.index, {this.parent, this.dateTime});

  @override
  void initState() {
    if(dateTime == null){
      dateTime = new DateTime.now();
    }
    _stopwatch.reset();
    _stopwatch.start();
  }

  // have some class or widget that carries both text field widgets for the exercise entries

  double _diffProg(difficulties) {
    //accepts list of difficulties for ones with reps
    var diffProg;
    diffProg = difficulties.reduce((a, b) => a + b)/difficulties.length;
    return diffProg;
  }

  Widget _buildAppBar() {
    return new AppBar(
      title: Text('New Workout Entry'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _stopwatch.stop();
            elapsedTime = _stopwatch.elapsed;
            _entryTitle = entryTitleController.text;
            if (_entryTitle == '') {
              _entryTitle = 'No Title';
            }
            if(exerciseList.length != 0){
              int i = 1;
              List difficulties = [];
              for (entryHolderState entry in exerciseList) {
                String exerciseText = "Exercise " + i.toString();
                int repsText = 0;
                print(entry.repsText.text);
                if(entry.exerciseText.text != '') {
                  exerciseText = entry.exerciseText.text;
                }
                if(entry.repsText.text != '') {
                  repsText = int.parse(entry.repsText.text);
                }
                if(exerciseText != '' && repsText != 0){
                  exer_reps.putIfAbsent(exerciseText, () => repsText);
                  difficulties.add(diffValues[entry.dropdownValue]);
                }

                i += 1;
              }

              //Calculates difficulty
              if (difficulties.length > 0) {
                 diffProg = _diffProg(difficulties);
              }
            }
            Navigator.of(context)
                .pop(new ExerciseEntry(index, _entryTitle, exer_reps, dateTime, elapsedTime, diffProg: diffProg, parent: parent));
          },
          child: Text(
            'Save',
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }

  void _onPressed() {
    setState(() {
      if(exerciseList.length != 0) {
        for (entryHolderState entry in exerciseList) {
          String exerciseText;
          int repsText;
          print(entry.repsText.text);
          if(entry.exerciseText.text != '') {
            exerciseText = entry.exerciseText.text;
          }
          if(entry.repsText.text != '') {
            repsText = int.parse(entry.repsText.text);
          }
          if(exerciseText != null && repsText != ''){
            exer_reps.putIfAbsent(exerciseText, () => repsText);
          }
        }
      }
      exerciseList.add(new entryHolderState());

    });
  }


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              autocorrect: true,
              autofocus: false,
              controller: entryTitleController,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 28,
              ),
              decoration: InputDecoration(
                hintText: 'Workout title',
                hintStyle: TextStyle(
                  fontSize: 28,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .90,
            child: Card(
              elevation: 3,
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: exerciseList.length,
                      itemBuilder: (context, index) {
                        final item = exerciseList[index];
                        return item.build(context);
                      }),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: _onPressed,
                      child: Icon(Icons.add),
                      mini: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class entryHolder extends StatefulWidget {
  @override
  State createState() => new entryHolderState();
}

class entryHolderState extends State<entryHolder>{
  static double screen_width;
  final exerciseText = TextEditingController();
  final repsText = TextEditingController();
  String dropdownValue = 'Easy';


  @override
  Widget build(BuildContext context){
    return new Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          width: 140,
          child: TextField(
            autocorrect: true,
            autofocus: false,
            controller: this.exerciseText,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: 'Exercise',
              hintStyle: TextStyle(
                fontSize: 20,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ),
        Container(
          width: 60,
          child: TextField(
            autocorrect: true,
            autofocus: false,
            keyboardType: TextInputType.number,
            controller: this.repsText,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: 'Reps',
              hintStyle: TextStyle(
                fontSize: 20,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ),

        DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
              dropdownValue = newValue;
          },
          items: <String>['Easy', 'Medium', 'Difficult']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );

  }
}
