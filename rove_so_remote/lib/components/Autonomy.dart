import 'package:flutter/material.dart';

class AutonomyView extends StatefulWidget {
  @override
  _AutonomyViewState createState() => _AutonomyViewState();
}

class _AutonomyViewState extends State<AutonomyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Autonomy"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Current Location:"),
            ],
          ),
        ));
  }
}
