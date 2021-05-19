import 'package:flutter/material.dart';
import '../RoveComm.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LightingView extends StatefulWidget {
  @override
  _LightingViewState createState() => _LightingViewState();
}

class _LightingViewState extends State<LightingView> {
  // Variables to keep track of states we can send to indicate operation of Rover
  String dropdownValue = 'Teleop';
  List<String> State = <String>['Teleop', 'Autonomy', 'Reached Goal'];
  List<String> Pattern = <String>[
    'Block',
    'Belgium',
    'Rover Swoosh',
    'Face',
    'US'
  ];

  // Variables to keep track of colors selected from Color Picker, so we can send random
  // RGB to panel
  Color pickerColor = Colors.blue;
  Color currentColor = Colors.blue;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

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
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
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
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // use whichever suits your need
          children: [
            Text("Pattern:"),
            DropdownButton<String>(
              value: dropdownValue,
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: Pattern.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
                child: Text("Send"),
                onPressed: () {
                  RC_Node.sendCommand("7002", DataTypes.UINT8_T,
                      Pattern.indexOf(dropdownValue), "192.168.1.140", false);
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("RGB: "),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: currentColor, // background
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentColor,
                          onColorChanged: changeColor,
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: false,
                          displayThumbColor: true,
                          showLabel: true,
                          paletteType: PaletteType.hsv,
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(2.0),
                            topRight: const Radius.circular(2.0),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              setState(() => currentColor = pickerColor);
                              Navigator.of(context).pop();
                            },
                            child: Text("Got it"))
                      ],
                    );
                  },
                );
              },
              child: const Text('Select Color'),
            ),
            ElevatedButton(
                child: Text("Send"),
                onPressed: () {
                  RC_Node.sendCommand(
                      "7001",
                      DataTypes.UINT8_T,
                      [currentColor.red, currentColor.green, currentColor.blue],
                      "192.168.1.140",
                      false);
                }),
          ],
        )
      ],
    ));
  }
}
