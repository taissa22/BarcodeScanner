import 'package:barcode_recognizer/camera/capture_button.dart';
import 'package:flutter/material.dart';
import 'package:barcode_recognizer/camera/camera_viewer.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Stack(
      alignment: Alignment.center,
      children: const [
        CameraViewer(),
        CaptureButton(),
    ],
    );
  }
}
