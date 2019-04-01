import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';

void main() => runApp(new Camerapicker());

class Camerapicker extends StatefulWidget {
  @override
  _CamerapickerState createState() => _CamerapickerState();
}

String cam_path;

Future<Null> uploadFile(String filepath) async {
  final ByteData bytes = await rootBundle.load(filepath);
  final Directory tempDir = Directory.systemTemp;
  final String fileName = "${Random().nextInt(10000)}.jpg";
  final File file = File('${tempDir.path}/$fileName');
  file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

  final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
  final StorageUploadTask task = ref.putFile(file);
  final Uri downloadUrl = (await task.future).downloadUrl;
  cam_path = downloadUrl.toString();

  print(cam_path);
}

class _CamerapickerState extends State<Camerapicker> {
  File camera;
  String cam_img;
  String fileNames = "assets/images/login-screen-background.png";
//  To use Gallery or File Manager to pick Image
//  Comment Line No. 19 and uncomment Line number 20
  picker() async {
    print('Camera Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      camera = img;
      fileNames = img.path.toString();


      print(fileNames);

      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Analise'),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black, size: 20.0),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: new Container(
          child: Column(
            children: <Widget>[
              new Center(
                child: camera == null
                    ? new Text('camera')
                    : new Image.file(camera),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: new RaisedButton(
                  onPressed: () async {
                    await uploadFile(fileNames);
                    print(fileNames);
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: new Text("Upload Photo"),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: picker,
          child: new Icon(Icons.photo_camera,
              color: Colors.lightBlueAccent, size: 36.0),
        ),
      ),
    );
  }
}

