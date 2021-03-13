import 'package:flutter/material.dart';

double drivePower = 300;

void setDrivePower(double val) {
  drivePower = val;
}

double getDrivePower() {
  return drivePower;
}

double restartTime = 0;

void setRestartTime(double val) {
  restartTime = val;
}

double getRestartTime() {
  return restartTime;
}

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  double _currentDriveSliderValue = 20;
  double _currentRestartSliderValue = 20;

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
              Text("Drive Power:"),
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
              Text("Restart Time:"),
              Slider(
                value: restartTime,
                min: 0,
                max: 20,
                label: restartTime.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    setRestartTime(value);
                  });
                },
              ),
              Text(
                "${restartTime.round()}",
              ),
            ],
          ),
        ));
  }
}
