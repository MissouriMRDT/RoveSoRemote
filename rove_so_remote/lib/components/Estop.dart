import 'package:flutter/material.dart';
import '../RoveComm.dart';

class EStopView extends StatefulWidget {
  @override
  _EStopViewState createState() => _EStopViewState();
}

class _EStopViewState extends State<EStopView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
            width: 2 * MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 3,
            child: ElevatedButton(
                onPressed: () {
                  RC_Node.sendCommand(
                      "2000", DataTypes.UINT8_T, 0, "192.168.1.133", false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.red;
                      return Colors.green; // Use the component's default.
                    },
                  ),
                ),
                child: Text("Estop"))),
      ),
    );
  }
}
