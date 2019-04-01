// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:location_picker/location_picker.dart';

// void main() => runApp(new Mylocation());

// class Mylocation extends StatefulWidget {
//   @override
//   _MylocationState createState() => new _MylocationState();
// }

// String locationPickerData = 'locationPicker';

// class _MylocationState extends State<Mylocation> {

//   Map<dynamic, dynamic> result = new Map();
//   @override
//   initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   initPlatformState() async {
//     LocationPicker.initApiKey('AIzaSyBU7vVDJkSFCWuzH9vm5Y7AExJHKlRGdBE');
//     LocationPicker picker = new LocationPicker();
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await picker.showLocationPicker;
//     } on PlatformException {}
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       locationPickerData = result
//           .toString()
//           .replaceFirst("{", " ")
//           .replaceFirst("}", " ")
//           .replaceAll(",", " \n")
//           .trim();
//     });
//     print("Done");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Report Location'),
//         ),
//         body: new ListView(children: [
//           new Padding(padding: const EdgeInsets.all(5.0)),
//           new Card(
//             elevation: 10.0,
//             child: new Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: new Text(
//                 locationPickerData,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 16.0,
//                     wordSpacing: 2.0,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: new RaisedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               color: Colors.lightBlueAccent,
//               textColor: Colors.white,
//               child: new Text(
//                 "SUBMIT LOCATION",
//                 style: TextStyle(fontSize: 15.0),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
