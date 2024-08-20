import "package:flutter/material.dart";

class CaptureButton extends StatelessWidget {
  const CaptureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 30,
        child: Container(
          height: 80,
          width: 80,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white60, width: 5),
              shape: BoxShape.circle),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child:
                  Icon(Icons.camera_alt_outlined, size: 60, color: Colors.grey),
            ),
          ),
        ));
  }
}
