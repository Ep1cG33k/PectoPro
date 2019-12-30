import 'package:flutter/material.dart';
import 'package:push_up_pro/sub/new_entry.dart';
import 'package:push_up_pro/sub/exercise_entry.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

class InsightsWidget extends StatefulWidget {

  bool animate;
  InsightsWidgetState parent;
  EntryStorage storage;

  InsightsWidget({animate}) {
    this.animate = animate;
  }

  @override
  //InsightsWidgetState parent = new InsightsWidgetState();
  State createState() => new InsightsWidgetState();
}


class Reps {
  final int exerciseNum;
  final int reps;

  Reps(this.exerciseNum, this.reps);
}

class InsightsWidgetState extends State<InsightsWidget> {

  static List<charts.Series<Reps, int>> _createData() {

    print("Creating Data");
    List<Reps> data = [
      new Reps(0, 0),
    ];

    ExerciseEntry recentEx;
    //get most recent exercise entry to graph values from
    if(insightsItems.length > 1) {
      recentEx = insightsItems[1];

      //TODO: Make it such that (0,0) is deleted
      var _exerciseList = recentEx.exercises.values.toList();
      print(_exerciseList);
      if (_exerciseList.length > 0) {
        data = [];
        for (int i = 0; i < _exerciseList.length; i++) {
          data.add(new Reps(i, _exerciseList[i]));
          print(i);
          print(_exerciseList[i]);
        }
      }
    }

    return [
      new charts.Series<Reps, int>(
        id: 'Reps',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Reps reps, _) => reps.exerciseNum,
        measureFn: (Reps reps, _) => reps.reps,
        data: data,
      )
    ];
  }

  Widget _horizontalList;
  //LocalStorage storage = new LocalStorage('ekindartfile');

  static List<ListItem> insightsItems = <ListItem>[
//    ExerciseEntry("chest", 19, new InsightsWidgetState()),
//    ExerciseEntry("back", 20, new InsightsWidgetState()),
  ];

  static Container _createGraph(data){
    return new Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            height: 210,
            width: 320,
            child: Card(
              elevation: 3,
              child: new charts.LineChart(data),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
      _horizontalList = _createGraph(_createData());

    if(insightsItems.length > 0){
      if(insightsItems[0] is ExerciseEntry){
        insightsItems.insert(0, GraphContainer(_horizontalList));
      }
    } else {
      insightsItems.insert(0, GraphContainer(_horizontalList));
    }

    for(ListItem item in insightsItems){
      if(item is ExerciseEntry){
        item.setParent(this);
        item.setIndex(insightsItems.indexOf(item));
      }
    }

    //insightsItems = storage.getItem('key');
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(8),
          itemCount: insightsItems.length,
          itemBuilder: (context, index){
            final item = insightsItems[index];

            if(item is GraphContainer) {
              return item.graphList;
            } else if (item is ExerciseEntry) {
              return item;
            }
          }
      ),
      floatingActionButton: _buildFloatingActionButton()
      );
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
      insightsItems.insert(1, newEntry);
      for(ListItem item in insightsItems){
        if(item is ExerciseEntry){
          item.setParent(this);
          item.setIndex(insightsItems.indexOf(item));
        }
      }
      insightsItems[0] = GraphContainer(_createGraph(_createData()));
//      storage.setItem('key', insightsItems);
//      insightsItems = storage.getItem('key');

    });
  }

  Future _openNewEntryDialog() async {
    ExerciseEntry newEntry =
    await Navigator.of(context).push(new MaterialPageRoute<ExerciseEntry>(
      builder: (BuildContext context) {
        return new NewEntryDialog(1, parent: this);
      },
      fullscreenDialog: true,
    ));
    if (newEntry != null) {
      _addEntry(newEntry);
    }
  }

}

abstract class ListItem{}

class GraphContainer implements ListItem {
  final Container graphList;

  GraphContainer(this.graphList);
}

class ExerciseCard implements ListItem {
  final ExerciseEntry entry;

  ExerciseCard(this.entry);
}

class GoalCard implements ListItem {
  final double goal;

  GoalCard(this.goal);
}

//Class for local storage
class EntryStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/entries.txt');
  }

  Future<Map<String, dynamic>> readEntry() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

//      return int.parse(contents);

    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File> writeEntry(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}