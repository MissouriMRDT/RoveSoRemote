import 'package:flutter/material.dart';

double drivePower = 300;

void setDrivePower(double val) {
  drivePower = val;
}

double getDrivePower() {
  return drivePower;
}

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Drive Power"),
              Slider(
                value: drivePower,
                min: 0,
                max: 1000,
                label: drivePower.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    setDrivePower(value);
                  });
                },
              ),
              Text(
                "${drivePower.round()}",
              ),
            ],
          ),
        ));
  }
}
