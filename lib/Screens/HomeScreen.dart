import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home screen"),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              DatabaseReference dbref =
                  FirebaseDatabase.instance.reference().child('test');
              dbref.set('isConnected');
            },
            child: Text("Test connection"),
          ),
        ),
      ),
    );
  }
}
