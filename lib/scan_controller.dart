import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  CameraImage? _cameraImage;
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
        model: "assets/model/model.tflite",
        labels: "assets/model/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
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
            print(e);
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
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5, // defaults to 127.5
      imageStd: 127.5, // defaults to 127.5
      rotation: 90, // defaults to 90, Android only
      threshold: 0.1, // defaults to 0.1
      asynch: true // defaults to true
      );

  print("finding");
  if (recognitions != null) {
    if (recognitions[0]['confidence'] > 0) {
      print(recognitions[0]['label']);
    }
  }
}
