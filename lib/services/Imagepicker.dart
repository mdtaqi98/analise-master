import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;



void main() => runApp(new Imagepicker());

class Imagepicker extends StatefulWidget {
  @override
  _ImagepickerState createState() => _ImagepickerState();
}



String gal_path;

Future<Null> uploadFile(String filepath) async {
  final ByteData bytes = await rootBundle.load(filepath);
  final Directory tempDir = Directory.systemTemp;
  final String fileName = "${Random().nextInt(10000)}.jpg";
  final File file = File('${tempDir.path}/$fileName');
  file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

  final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
  final StorageUploadTask task = ref.putFile(file);
  final Uri downloadUrl = (await task.future).downloadUrl;
  gal_path = downloadUrl.toString();

  print(gal_path);
}


class _ImagepickerState extends State<Imagepicker> {
  File gal_image;
  String fileNames = "assets/images/login-screen-background.png";
//  To use Gallery or File Manager to pick Image
//  Comment Line No. 19 and uncomment Line number 20
  picker() async {
    print('Image Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      gal_image = img;
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
                child: gal_image == null ? new Text('photos') : new Image.file(gal_image),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
          child: new Icon(Icons.add_a_photo,
              color: Colors.lightBlueAccent, size: 36.0),
        ),
      ),
    );
  }
}
