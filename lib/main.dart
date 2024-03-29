import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  var data = await readData();
  if (data != null) {
    String message = await readData();
    print(message);
  }

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'IO',
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var _enterDataField = new TextEditingController();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Read/Write'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: new Container(
          child: new ListTile(
        title: new TextField(
          decoration: InputDecoration(
            labelText: 'Write Something',
          ),
          controller: _enterDataField,
        ),
        subtitle: FlatButton(
          onPressed: () {
            writeData(_enterDataField.text);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text('Save Data'),
              new Padding(padding: new EdgeInsets.all(14.5)),
              new FutureBuilder(
                  future: readData(),
                  builder: (BuildContext context, AsyncSnapshot<String> data) {
                    if (data.hasData != null) {
                      return new Text(
                        data.data.toString(),
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      );
                    } else {
                      return new Text('No Data Saved!');
                    }
                  }),
            ],
          ),
          color: Colors.redAccent,
        ),
      )),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/data.txt'); //home/directory/data.txt
}

Future<File> writeData(String message) async {
  final file = await _localFile;
  return file.writeAsString('$message');
}

Future<String> readData() async {
  try {
    final file = await _localFile;
    //read
    String data = await file.readAsString();
    return data;
  } catch (e) {
    return "Nothing saved yet!";
  }
}
