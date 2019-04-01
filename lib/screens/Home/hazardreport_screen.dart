import 'package:analise_test/screens/Login/index.dart';
import 'package:analise_test/services/Imagepicker.dart';
import 'package:analise_test/services/camerapicker.dart';
import 'package:analise_test/screens/Home/submit_report.dart';
import 'package:analise_test/screens/Home/coupon.dart';
import 'package:analise_test/screens/Home/profile.dart';
// import 'package:analise_test/services/reportlocation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:analise_test/services/authentication.dart';

void main() => runApp(new MyHome());

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new DateAndTimePickerDemo(),
//    routes:   <String,WidgetBuilder>{
//      "/h": (BuildContext context) => new HomePage('Report Hazard'),
//    }
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey
                    : Colors.white),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101, 12));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class DateAndTimePickerDemo extends StatefulWidget {
  static const String routeName = '/material/date-and-time-pickers';
  //fetch user data

  @override
  _DateAndTimePickerDemoState createState() =>
      new _DateAndTimePickerDemoState();
}

final List<String> _allActivities = <String>['Hazard', 'Near miss', 'Accident'];
String _activity = 'Hazard';

var Incident = _activity;

var Score = 30;

void setScore() {
  if (_activity == 'Hazard') {
    Score = 30;
  } else if (_activity == 'Near miss') {
    Score = 20;
  } else
    Score = 10;
}

DateTime fromDate = new DateTime.now();
TimeOfDay fromTime = const TimeOfDay(hour: 7, minute: 28);

var time = fromTime
    .toString()
    .replaceAll('TimeOfDay', "")
    .replaceFirst("(", " ")
    .replaceFirst(")", " ")
    .trim();

var companynameController = new TextEditingController();
var companyname = companynameController.text;
var incidentdetailsController = new TextEditingController();
var incidentdetails = incidentdetailsController.text;

class _DateAndTimePickerDemoState extends State<DateAndTimePickerDemo> {
  UserData user = new UserData();
  UserAuth userAuth = new UserAuth();

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void logout() {
    userAuth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
//  print('Done');
  }

//Firebase db and storage
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String myText;
  StreamSubscription<DocumentSnapshot> subscription;
  String uuid = uid;

  int userTotalScore = userScore + Score;

  final DocumentReference documentReference = Firestore.instance
      .collection('$uid')
      .document('User Details')
      .collection('Reports')
      .document();
//  Firestore.instance.document("$uid/Report/");
  final DocumentReference docRef =
      Firestore.instance.collection('$uid').document('User Details');
  final DocumentReference docRefUsers =
      Firestore.instance.collection("$uid").document('User Details');

  void _add() {
    Map<String, Object> data = <String, Object>{
      "Date of Incident": fromDate,
      "Time Of incident": time,
      "Explain The Incident": incidentdetails,
      "Location Of Incident": "locationPickerData",
      "Name Of The Company": companyname,
      "Score": Score,
      "Type of Incident": Incident,
      "Url of Image from Camera": cam_path,
      "Url of Image from Gallery": gal_path
    };

    documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
    docRef.updateData({'Score': userTotalScore});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Analise'),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(userName),
                accountEmail: new Text(userEmail)),
            new ListTile(
                title: new Text('Report Hazard'),
                trailing: new Icon(Icons.report),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DateAndTimePickerDemo()),
                  );
                }),
            new ListTile(
              title: new Text('Profile'),
              trailing: new Icon(Icons.person),
              onTap: () {
                fetchuserdata();
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => userProfile()));
              },
            ),
            new ListTile(
              title: new Text('Coupons'),
              trailing: new Icon(Icons.card_giftcard),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => coupons()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text('Logout'),
              trailing: new Icon(Icons.exit_to_app),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: new DropdownButtonHideUnderline(
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              new TextField(
                controller: companynameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: const OutlineInputBorder(),
                ),
                style: Theme
                    .of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 18.0),
//                  onSubmitted: print(value),
              ),
              new Padding(padding: new EdgeInsets.all(12.0)),
              new TextField(
                controller: incidentdetailsController,
                decoration: const InputDecoration(
                  labelText: 'Explain the Incident',
                  border: const OutlineInputBorder(),
                ),
                style: Theme
                    .of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 18.0),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new _DateTimePicker(
                labelText: 'Date & Time of Incident',
                selectedDate: fromDate,
                selectedTime: fromTime,
                selectDate: (DateTime date) {
                  setState(() {
                    fromDate = date;
                    print(fromDate);
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    fromTime = time;
                    print(time);
                  });
                },
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Type of Incident',
                  hintText: 'Choose an Incident',
                ),
                isEmpty: _activity == null,
                child: new DropdownButton<String>(
                  value: _activity,
                  isDense: true,
                  onChanged: (Incident) {
                    setState(() {
                      _activity = Incident;
                      setScore();
                      print(Score);
                      print(Incident);
                    });
                  },
                  items: _allActivities.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
              new Padding(padding: new EdgeInsets.all(15.0)),
              new Row(
                children: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.add_a_photo,
                          color: Colors.lightBlueAccent, size: 36.0),
                      tooltip: 'add image',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Imagepicker()),
                        );
                      }),
                  new Padding(padding: new EdgeInsets.all(45.0)),
                  new IconButton(
                      icon: new Icon(Icons.camera,
                          color: Colors.lightBlueAccent, size: 36.0),
                      tooltip: 'Take a pic',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Camerapicker()),
                        );
                      }),
                  new Padding(padding: new EdgeInsets.all(45.0)),
                  new IconButton(
                      icon: new Icon(Icons.add_location,
                          color: Colors.lightBlueAccent, size: 36.0),
                      tooltip: 'Report Location',
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Mylocation()),
                        // );
                      }),
                ],
              ),
              new Padding(padding: new EdgeInsets.all(16.0)),
              new RaisedButton(
                onPressed: () {
                  _add();
                  print(uid);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => submitReport()));
                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: new Text("SUBMIT REPORT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
