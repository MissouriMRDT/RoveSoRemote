import 'package:flutter/material.dart';
import '../RoveComm.dart';

class LightingView extends StatefulWidget {
  @override
  _LightingViewState createState() => _LightingViewState();
}

class _LightingViewState extends State<LightingView> {
  String dropdownValue = 'Teleop';
  List<String> State = <String>['Teleop', 'Autonomy', 'Reached Goal'];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // use whichever suits your need
          children: [
            Text("State:"),
            DropdownButton<String>(
              value: dropdownValue,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: State.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
                child: Text("Send"),
                onPressed: () {
                  RC_Node.sendCommand("7003", DataTypes.UINT8_T,
                      State.indexOf(dropdownValue), "192.168.1.140", false);
                }),
          ],
        )
      ],
    ));
  }
}
