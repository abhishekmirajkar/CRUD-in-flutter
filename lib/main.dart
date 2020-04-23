import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      Firestore.instance.document("myData/dummy");

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Abhishek Mirajkar 1",
      "petname": "Maverick 1",
    };

    documentReference.setData(data).whenComplete(() {
      print("DATA ADDED INTO DATABASE");
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Abhishek Mirajkar Updated",
      "petname": "Maverick 2 Updated",
    };

    documentReference.updateData(data).whenComplete(() {
      print("DATA ADDED INTO DATABASE Updated");
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print("DELTED SUCCESSFULLY");
      MyText = null;
      setState(() {});
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          MyText = datasnapshot.data['name'];
          print(datasnapshot.data);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          MyText = datasnapshot.data['name'];
        });
      }
    });
  }

  String MyText = null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  onPressed: _add,
                  child: Text("Add"),
                  color: Colors.blue,
                ),
                new RaisedButton(
                  onPressed: _update,
                  child: Text("Update"),
                  color: Colors.blue,
                ),
                new RaisedButton(
                  onPressed: _delete,
                  child: Text("Delete"),
                  color: Colors.blue,
                ),
                new RaisedButton(
                  onPressed: _fetch,
                  child: Text("Fetch"),
                  color: Colors.blue,
                ),
                MyText == null
                    ? new Container()
                    : new Container(
                        child: Text(MyText),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
