import 'package:flutter/material.dart';
import 'hazardreport_screen.dart';


void main() => runApp(new submitReport());

class submitReport extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<submitReport> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Analise'),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white, size: 20.0),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body:  new ListView(
              children: [
                new Padding(padding: const EdgeInsets.all(5.0)),
                
                new Card(
                  elevation: 8.0,

                  child: new Padding(

                    padding: const EdgeInsets.all(15.0),
                    child: new Text('Thanks For Reporting, We will take the necessary action, You have earned $Score points!',style: TextStyle(fontSize: 20.0),)
                  ),
                ),
                new Padding(padding: new EdgeInsets.all(20.0)),

                new Padding(padding: new EdgeInsets.all(20.0)),
                new RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  child: new Text("OK"),
                ),
              ],
            ))

    );
  }




  }
























