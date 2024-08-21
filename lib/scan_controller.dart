import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late CameraImage? _cameraImage;
  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;
  int _imageCount = 0;

  @override
  void dispose() {
    _isInitialized.value = false;
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> _initTensorFlow() async {
    String? res = await Tflite.loadModel(
        model: "model/ssd_mobilenet.tflite",
        labels: "model/ssd_mobilenet.txt");
    print("model:");
    print(res);
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420);
    _cameraController.initialize().then((_) {
      _isInitialized.value = true;
      _cameraController.startImageStream((image) {
        _imageCount++;
        if (_imageCount % 10 == 0) {
          _imageCount = 0;
          _objectRecognition(image);
        }
      });
      _isInitialized.refresh();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Camera Access Denied");
          default:
            break;
        }
      }
    });
  }

  @override
  void onInit() {
    _initCamera();
    _initTensorFlow();
    super.onInit();
  }
}

Future<void> _objectRecognition(CameraImage cameraImage) async {
  var recognitions = await Tflite.detectObjectOnFrame(
      bytesList: cameraImage.planes.map((plane) {
        return plane.bytes;
      }).toList(), // required
      model: "SSDMobileNet",
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      threshold: 0.1,
      asynch: true);

  if (recognitions != null) {
    if (recognitions[0]['confidence'] > 0) {
      print(recognitions[0]['label']);
    }
  }
}
