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

  void sendDriveCommand(double direction, double magnitude) {
    if (DateTime.now().millisecondsSinceEpoch - timeLast > 100) {
      print("Magnitude: $magnitude");
      print("Direction: $direction");
      int left = 0;
      int right = 0;
      if (direction > 150 && direction < 210) {
        left = -map_range(magnitude, 0, 1, 0, 300);
        right = -map_range(magnitude, 0, 1, 0, 300);

        RC_Node.sendCommand(
            "1000", DataTypes.INT16_T, [left, right], "192.168.1.134", false);
      } else if (direction > 330 || direction < 30) {
        left = map_range(magnitude, 0, 1, 0, 300);
        right = map_range(magnitude, 0, 1, 0, 300);

        RC_Node.sendCommand(
            "1000", DataTypes.INT16_T, [left, right], "192.168.1.134", false);
      }
      timeLast = DateTime.now().millisecondsSinceEpoch;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(RC_Node);
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
                    onDirectionChanged: sendDriveCommand),
              ],
            )
          ],
        ),
      ),
    );
  }
}
