import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  final int index;
  final String entryTitle;
  final Map<String, int> exercises;

  const EntryPage({Key key, this.index, this.entryTitle, this.exercises})
      : super(key: key);

  Widget _buildAppBar() {
    return new AppBar(
      title: Text(entryTitle),
    );
  }

  Widget _exerciseField(String exercise, int reps) {
    return new Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          width: 200,
          child: Text(
            exercise,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          width: 60,
          child: Text(
            reps.toString(),
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Hero(
        tag: "card$index",
        child: Scaffold(
          appBar: _buildAppBar(),
          body: new Column(
            children: <Widget>[
              Container(
                child: Text(
                  'Exercises',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),

              Center(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      String exerciseText = exercises.keys.elementAt(index);
                      int repsText = exercises.values.elementAt(index);
                      return _exerciseField(exerciseText, repsText);
                    }),
              )
            ],
          ),
        ));
  }
}
