import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraCamera(
        onFile: (file) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
