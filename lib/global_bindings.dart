
import 'package:get/get.dart';
import 'package:barcode_recognizer/scan_controller.dart';
import 'package:get/instance_manager.dart';

class GlobalBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(() => ScanController());
  }

}