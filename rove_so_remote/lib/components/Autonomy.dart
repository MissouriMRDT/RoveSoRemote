import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../RoveComm.dart';

class AutonomyView extends StatefulWidget {
  @override
  _AutonomyViewState createState() => _AutonomyViewState();
}

class _AutonomyViewState extends State<AutonomyView> {
  Position pos = Position(
      longitude: 0, latitude: 0, timestamp: DateTime(2018), accuracy: 0);

  Future<void> loadGPS() async {
    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  _AutonomyViewState() {
    // Load GPS for the first time
    loadGPS();

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
            .listen((Position position) {
      setState(() {
        pos = position;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Latitude: ${pos.latitude}"),
              Text("Longitude: ${pos.longitude}"),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                RC_Node.sendCommand(
                    manifest["Autonomy"]["Commands"]["AddWaypoints"]["dataId"],
                    DataTypes.DOUBLE_T,
                    [pos.latitude, pos.longitude],
                    manifest["Autonomy"]["Ip"],
                    false);
              },
              child: Text("Send Current Position as Waypoint")),
          ElevatedButton(
              onPressed: () {
                RC_Node.sendCommand(
                    manifest["Autonomy"]["Commands"]["ClearWaypoints"]
                        ["dataId"],
                    DataTypes.UINT8_T,
                    0,
                    manifest["Autonomy"]["Ip"],
                    false);
              },
              child: Text("Clear Waypoints")),
          SizedBox(height: MediaQuery.of(context).size.height / 6),
          ElevatedButton(
              onPressed: () {
                RC_Node.sendCommand(
                    manifest["Autonomy"]["Commands"]["StartAutonomy"]["dataId"],
                    DataTypes.UINT8_T,
                    0,
                    manifest["Autonomy"]["Ip"],
                    false);
              },
              child: Text("StartAutonomy")),
          ElevatedButton(
              onPressed: () {
                RC_Node.sendCommand(
                    manifest["Autonomy"]["Commands"]["DisableAutonomy"]
                        ["dataId"],
                    DataTypes.UINT8_T,
                    0,
                    manifest["Autonomy"]["Ip"],
                    false);
              },
              child: Text("Disable Autonomy"))
        ],
      ),
    );
  }
}
