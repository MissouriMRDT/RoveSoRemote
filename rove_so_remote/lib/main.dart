// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rove_so_remote/components/Drive.dart';
import 'package:rove_so_remote/components/Estop.dart';
import 'package:rove_so_remote/components/Lighting.dart';
import 'RoveComm.dart';
import 'dart:developer' as developer;
import 'package:control_pad/control_pad.dart';

void main() => runApp(RoveSoRemoteApp());

class RoveSoRemoteApp extends StatelessWidget {
  // touch RC_Node
  final rc = RC_Node;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RoveSoRemote',
        theme: ThemeData(primaryColor: Colors.red),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _HomePageState() {
    _widgetOptions = <Widget>[
      LightingView(),
      DriveView(),
      EStopView(),
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
          children: [_widgetOptions.elementAt(_selectedIndex)],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb), label: 'Lighting'),
          BottomNavigationBarItem(
              icon: Icon(Icons.two_wheeler), label: 'Driving'),
          BottomNavigationBarItem(icon: Icon(Icons.stop), label: 'Estop'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
