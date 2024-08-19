import 'package:barcode_recognizer/camera/camera_screen.dart';
import 'package:barcode_recognizer/global_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CameraScreen(),
      title: "Barcode Recognizer",
      initialBinding: GlobalBindings(),
    );
  }
}
