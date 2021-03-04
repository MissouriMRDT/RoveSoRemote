// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:rove_so_remote/RoveComm.dart';
import 'dart:developer' as developer;
import 'package:rove_so_remote/RoveComm.dart';

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  RoveComm rc = RoveComm();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(primaryColor: Colors.red),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  var textEntry = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RoveSoRemote"),
      ),
      body: Center(
        child: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
                child: Text("Hello"),
                onPressed: () {
                  _displayTextInputDialog(context);
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (text) {
                textEntry = text;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.ac_unit,
                    color: Colors.greenAccent,
                  ),
                  hintText: "Text Field in Dialog"),
              cursorColor: Colors.green,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close")),
              TextButton(
                  onPressed: () =>
                      developer.log(textEntry, name: 'my.app.category'),
                  child: Text("Send")),
            ],
          );
        });
  }
}
// #enddocregion build


