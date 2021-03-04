// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rove_so_remote/RoveComm.dart';
import 'dart:developer' as developer;
import 'package:control_pad/control_pad.dart';

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(primaryColor: Colors.red),
        home: HomePage());
  }
}

int map_range(double x, int in_min, int in_max, int out_min, int out_max) {
  return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)
      .round();
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var textEntry = "";
  int _selectedIndex = 0;
  RoveComm rc = RoveComm();
  List<List<Widget>> _widgetOptions;
  var timeLast = DateTime.now().millisecondsSinceEpoch;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void sendDriveCommand(double direction, double magnitude) {
    if (DateTime.now().millisecondsSinceEpoch - timeLast > 100) {
      print("Magnitude: $magnitude");
      print("Direction: $direction");
      int left = 0;
      int right = 0;
      if (direction > 150 && direction < 210) {
        left = -map_range(magnitude, 0, 1, 0, 300);
        right = -map_range(magnitude, 0, 1, 0, 300);

        rc.sendCommand(
            "1000", DataTypes.INT16_T, [left, right], "192.168.1.134", false);
      } else if (direction > 330 || direction < 30) {
        left = map_range(magnitude, 0, 1, 0, 300);
        right = map_range(magnitude, 0, 1, 0, 300);

        rc.sendCommand(
            "1000", DataTypes.INT16_T, [left, right], "192.168.1.134", false);
      }
      timeLast = DateTime.now().millisecondsSinceEpoch;
    }
  }

  _HomePageState() {
    _widgetOptions = [
      <Widget>[
        ElevatedButton(
            child: Text("Send Teleop"),
            onPressed: () {
              rc.sendCommand(
                  "7003", DataTypes.UINT8_T, 0, "192.168.1.140", false);
            }),
        ElevatedButton(
            child: Text("Send Auto"),
            onPressed: () {
              rc.sendCommand(
                  "7003", DataTypes.UINT8_T, 1, "192.168.1.140", false);
            }),
        ElevatedButton(
            child: Text("Send Reached"),
            onPressed: () {
              rc.sendCommand(
                  "7003", DataTypes.UINT8_T, 2, "192.168.1.140", false);
            }),
      ],
      [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // use whichever suits your need

          children: [
            JoystickView(size: 150, onDirectionChanged: sendDriveCommand),
          ],
        )
      ]
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RoveSoRemote"),
        actions: [
          IconButton(icon: Icon(Icons.wifi), onPressed: () => null),
        ],
      ),
      body: Center(
        child: Column(
          children: _widgetOptions.elementAt(_selectedIndex),
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb), label: 'Lighting'),
          BottomNavigationBarItem(
              icon: Icon(Icons.two_wheeler), label: 'Driving'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TextWidget extends StatefulWidget {
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var roveCommString = "";

  void updateText(data) {
    setState(() {
      roveCommString = data.toString();
    });
    print(roveCommString);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callbacks[1001] = [
      updateText,
    ];
    return Text("$roveCommString");
  }
}
// #enddocregion build


