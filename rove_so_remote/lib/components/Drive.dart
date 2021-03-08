import 'dart:async';

import 'package:flutter/material.dart';
import '../RoveComm.dart';
import 'dart:developer' as developer;
import 'package:control_pad/control_pad.dart';

int map_range(double x, int in_min, int in_max, int out_min, int out_max) {
  return ((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)
      .round();
}

class DriveView extends StatefulWidget {
  @override
  _DriveViewState createState() => _DriveViewState();
}

class _DriveViewState extends State<DriveView> {
  var timeLast = DateTime.now().millisecondsSinceEpoch;
  int leftSpeed = 0;
  int rightSpeed = 0;
  Timer timer;

  int setSpeed(double direction, double magnitude) {
    if (direction > 150 && direction < 210) {
      return -map_range(magnitude, 0, 1, 0, 300);
    } else if (direction > 330 || direction < 30) {
      return map_range(magnitude, 0, 1, 0, 300);
    } else {
      return 0;
    }
  }

  void sendDriveCommand() {
    print("Sending");
    RC_Node.sendCommand("1000", DataTypes.INT16_T, [leftSpeed, rightSpeed],
        "192.168.1.133", false);
  }

  @override
  void initState() {
    timer = new Timer.periodic(
        Duration(milliseconds: 100), (Timer t) => sendDriveCommand());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // use whichever suits your need

              children: [
                JoystickView(
                    size: 150,
                    interval: Duration(milliseconds: 50),
                    onDirectionChanged: (dir, mag) =>
                        {leftSpeed = setSpeed(dir, mag)}),
                JoystickView(
                    size: 150,
                    interval: Duration(milliseconds: 50),
                    onDirectionChanged: (dir, mag) =>
                        {rightSpeed = setSpeed(dir, mag)}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
