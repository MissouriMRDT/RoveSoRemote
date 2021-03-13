import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
              'https://s3-us-west-2.amazonaws.com/static.pyimagesearch.com/imagezmq-opencv/imagezmq_demo.gif')
        ],
      ),
    ));
  }
}
